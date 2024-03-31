template <class F> auto finally(F f) noexcept(noexcept(F(std::move(f)))) {
  auto x = [f = std::move(f)](void *) { f(); };
  return std::unique_ptr<void, decltype(x)>((void *)1, std::move(x));
}
// auto guard = finally([&]{ final_action(); });

template<class F>
[[nodiscard]] auto on_throw(F f) noexcept(noexcept(F(std::move(f)))) {
    auto x = [f = std::move(f)](void* p){
        if((intptr_t)p > std::uncaught_exceptions()) f();
    };
    return std::unique_ptr<void, decltype(x)>(
        (void*)(intptr_t)(std::uncaught_exceptions() + 1), std::move(x));
}
// auto rollback = on_throw([&]{ do_rollback(); });
