func (s *serverHandler) UploadUpdates(w http.ResponseWriter, r *http.Request) {
	app := r.FormValue("app")
	ver := r.FormValue("v")
	token := r.FormValue("token")
	if token != "ata" {
		w.WriteHeader(403)
		return
	}

	if !(app == "manager" || app == "client") {
		w.WriteHeader(400)
		fmt.Fprintf(w, "app must be a valid value")
		return
	}
	if ver == "" {
		w.WriteHeader(400)
		fmt.Fprintf(w, "ver: version must be a valid value")
		return
	}

	// 解析文件
	r.ParseMultipartForm(32 << 20) //32MB
	file, handler, err := r.FormFile("file")
	if err != nil {
		w.WriteHeader(400)
		fmt.Fprintf(w, "file must be provided")
		return
	}

	defer file.Close()

	// 保存文件
	p := path.Join(s.conf.UpdatesRoot, ver)
	if _, err := os.Stat(p); os.IsNotExist(err) {
		os.MkdirAll(p, 0755)
	}
	f, err := os.OpenFile(path.Join(p, handler.Filename), os.O_WRONLY|os.O_CREATE, 0666)
	if err != nil {
		fmt.Println(err)
		return
	}
	defer f.Close()
	io.Copy(f, file)

	w.WriteHeader(http.StatusOK)
}

func (s *serverHandler) UploadFile(w http.ResponseWriter, r *http.Request) {
	ver := r.URL.Query().Get("ver")
	name := filepath.Base(r.URL.Query().Get("name"))
	size := r.ContentLength
	if !versionRegexp.MatchString(ver) || name == "" { //缺少参数
		w.WriteHeader(400)
		return
	}

	if size > 100*1024*1024 { // 100MB
		w.WriteHeader(400)
		return
	}

	fn := path.Join(s.conf.UpdatesRoot, ver, name)
	f, err := os.OpenFile(fn, os.O_WRONLY|os.O_CREATE, 0666)
	if err != nil {
		log.Println(err)
		return
	}

	failed := false
	cleanup := func() {
		f.Close()
		if failed {
			os.Remove(fn)
		}
	}
	defer cleanup()

	bytes, err := io.Copy(f, r.Body)
	if err != nil {
		failed = true
		log.Println(err)
		w.WriteHeader(500)
		return
	}

	if bytes != size {
		failed = true
		w.WriteHeader(400)
		return
	}

	s.sendJSON(w, Json{"url": "tttt"})
}

func (*serverHandler) sendJSON(w http.ResponseWriter, data interface{}) {
	w.Header().Set("Content-Type", "application/json; charset=UTF-8")
	w.WriteHeader(http.StatusOK)
	if err := json.NewEncoder(w).Encode(data); err != nil {
		http.Error(w, http.StatusText(500), 500)
	}
}
