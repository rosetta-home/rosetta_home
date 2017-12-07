import { createStore, applyMiddleware } from 'redux';
import * as types from './types';
import { sendAction } from './actions';
import { emit } from './util/websocket'
import { num_data_points } from './common/config'


let ACTIONS = {
  SEND_ACTION: ({...state}, {action, payload}) => {
    var obj = {}
		obj[action] = payload;
		emit(sendAction(action, payload));
		return Object.assign(state, obj)
  },

  ACTION: function({...state}, {action, payload}){
    console.log(action);
    console.log(payload);
    return state;
  },

	DATA: function({...state}, data){
    console.log(data);
    return state;
  },

	DATA_POINT: function({...state}, msg){
    msg.timestamp = new Date();
    var type = msg.data_point.type;
    var id = msg.data_point.interface_pid;
    var dps = state[type][id] || [];
    var data_points = [...dps, msg];
		if(data_points.length > num_data_points) data_points = data_points.slice(1, num_data_points+1);
    var obj = JSON.parse(JSON.stringify(state));
    obj[type][id] = data_points;
		return obj;
  },

  UPDATE_DATA: function({...state}, data){
    for(var type in state){
      var t = state[type];
      for(var device in t){
        var d = t[device];
        var dp = JSON.parse(JSON.stringify(d[d.length-1]));
        dp.timestamp = new Date();
        d.push(dp);
        if(d.length > num_data_points) d = d.slice(1, num_data_points+1);
      }
    }
    return JSON.parse(JSON.stringify(state));
  }

};

const INITIAL = {
	hvac: {},
  ieq: {},
  weather_station: {},
  energy: {},
};

export default createStore( (state, action) => (
	action && ACTIONS[action.type] ? ACTIONS[action.type](state, action) : state
), INITIAL);
