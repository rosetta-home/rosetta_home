import { createStore, applyMiddleware } from 'redux';
import * as types from './types';
import { sendAction } from './actions';
import { emit } from './util/websocket'


let ACTIONS = {
	ADD_TODO: function({ todos, ...state }, { text }){
    emit(sendAction('todo', {text: text}));
		return {
      todos: [...todos, {
			  id: Math.random().toString(36).substring(2),
			  text
		  }],
		  ...state
    }
  },

	REMOVE_TODO: ({ todos, ...state }, { todo }) => ({
		todos: todos.filter( i => i!==todo ),
		...state
	}),

  SEND_ACTION: ({...state}, {action, payload}) => (
    state
  ),

  RECEIVE_ACTION: function({...state}, {action, payload}){
    console.log(action);
    console.log(payload);
    return state;
  }
};

const INITIAL = {
	todos: [],
};

export default createStore( (state, action) => (
	action && ACTIONS[action.type] ? ACTIONS[action.type](state, action) : state
), INITIAL);
