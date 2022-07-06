    ctx = ssl.create_default_context()
    ctx.check_hostname = False
    ctx.verify_mode = ssl.CERT_NONE
    with socket.create_connection((hostname, port)) as sock:
        with ctx.wrap_socket(sock, server_hostname=hostname) as ssock:
            print(ssl.DER_cert_to_PEM_cert(ssock.getpeercert(True)), end='')

