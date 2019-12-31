function getOutboundIP(): Promise<string> {
  return new Promise<string>((resolve, reject) => {
    const client = dgram.createSocket('udp4') as any;
    client.connect(80, '8.8.8.8', (err: any) => {
      if (err) {
        return err.code == 'ENETUNREACH' ? resolve('127.0.0.1') : reject(err);
      }
      resolve(client.address().address);
    });
    setTimeout(() => {
      client.close();
    }, 0);
  });
}
