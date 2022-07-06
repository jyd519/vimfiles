
#[cfg(feature = "bundled")]
fn run_command(cmd: &str, args: &[&str]) {
    use std::process::Command;
    match Command::new(cmd).args(args).output() {
        Ok(output) => {
            if !output.status.success() {
                let error = std::str::from_utf8(&output.stderr).unwrap();
                panic!("Command '{}' failed: {}", cmd, error);
            }
        }
        Err(error) => {
            panic!("Error running command '{}': {:#}", cmd, error);
        }
    }
}

#[cfg(feature = "bundled")]
fn download_to(url: &str, dest: &str) {
    if cfg!(windows) {
        run_command("powershell", &[
            "-NoProfile", "-NonInteractive",
            "-Command", &format!("& {{
                $client = New-Object System.Net.WebClient
                $client.DownloadFile(\"{0}\", \"{1}\")
                if (!$?) {{ Exit 1 }}
            }}", url, dest).as_str()
        ]);
    } else {
        run_command("curl", &[url, "-o", dest]);
    }
}
