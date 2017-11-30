import { receiveAction } from '../actions';
import { host, port } from '../common/config';
import store from '../store';

const socket = new WebSocket(host+":"+port);
socket.onmessage = message_handler;
socket.onopen = connect_handler;
socket.onclose = close_handler;

export const emit = (action) => socket.send(JSON.stringify(action))

function message_handler(message){
  var data_p = JSON.parse(message.data);
  store.dispatch(
    receiveAction(data_p.action, data_p.payload)
  );
}

function connect_handler(e){
  console.log("WS connected");
  console.log(e);
}

function close_handler(e){
  console.log("WS closed");
  console.log(e);
}
