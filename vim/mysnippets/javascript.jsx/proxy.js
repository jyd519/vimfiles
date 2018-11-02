// proxy server
var proxy = net.createServer(function (socket) {
    var client;

    console.log('Client connected to proxy');

    // Create a new connection to the TCP server
    client = net.connect(tcpServerPort);

    // 2-way pipe between client and TCP server
    socket.pipe(client).pipe(socket);

    socket.on('close', function () {
        console.log('Client disconnected from proxy');
    });

    socket.on('error', function (err) {
        console.log('Error: ' + err.soString());
    });
});
