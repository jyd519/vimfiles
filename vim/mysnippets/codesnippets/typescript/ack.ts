//
// 记录已处理消息的ID
//

export function init() {
  setInterval(cleanupIdMap, 300000); // 5m
}

export function isHandled(id: number, peer: {address, port}): boolean {
  const info = getKey(peer);
  return info.has(id);
}

export function addMsgId(id: number, peer: {address, port}) {
  if (id) {
    const info = getKey(peer);
    info.add(id);
  }
}

const MAX_NUM_ID = 100;
const data: PeerMap = {};

class AckInfo {
  ids: number[];
  next: number;
  time: number;

  constructor() {
    this.ids = new Array(MAX_NUM_ID);
    this.next = 0;
    this.time = new Date().getTime();
  }

  add(id: number) {
    if (this.has(id)) return;
    this.ids[this.next++ % MAX_NUM_ID] = id;
    this.time = new Date().getTime();
  }

  has(id: number) {
    for (let i = 0, len = this.ids.length; i < len; ++i) {
      if (this.ids[i] === id) {
        return true;
      }
    }
    return false;
  }
}

interface PeerMap {
  [key: string]: AckInfo;
}

function cleanupIdMap() {
  const now = new Date().getTime();
  Object.keys(data).forEach((key) => {
    const val = data[key];
    if (Math.abs(now - val.time) > 60000) {
      delete data[key];
    }
  });
}

function getKey(peer: {address, port}): AckInfo {
  const key = peer.address + "-" + peer.port;
  if (!data[key]) {
    data[key] = new AckInfo();
  }
  return data[key];
}
