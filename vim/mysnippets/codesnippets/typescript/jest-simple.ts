function factorialize(num) {
    if (num < 0) return -1;
    else if (num == 0) return 1;
    else {
        return num * factorialize(num - 1);
    }
}

// One-Time Setup
beforeAll(() => {
    // do some setup 
})

afterAll(() => {
    //do some teardown 
})

// Repeating setup for each test
beforeEach(() => {
    // Initialize objects 
});
afterEach(() => {
    // Tear down objects 
});

test("factorial of 3", () => {
    expect(factorialize(3)).toBe(6);
});

test(`test async function`, async () => {
    const str = await async function() {
        console.log('async function');
    }();

    expect(str).toBe("gnirtS");
});

test(`test callback function`, (done) => {
    function foo(str, callback) {
        callback(str.toUpperCase());
    }
    foo('gnirts', (str) => {
        expect(str).toBe('gnirts');
        done();
    })
});

// Grouping Tests
describe('testing factorial function', () => {
    // Isolated Setup
    beforeAll(() => {
        //do something
    })
    afterAll(() => {
        //do something
    })

    test("factorial of 3", () => {
        expect(factorialize(3)).toBe(6);
    });

    test("factorial of 5", () => {
        expect(factorialize(5)).toBe(120);
    });

    test("factorial of 3 is not 5", () => {
        expect(factorialize(3)).not.toBe(5);
    });
})
