
import * as types from './types'

export function sendAction(action, payload) {
	return {
		type: types.SEND_ACTION,
		action: action,
		payload: payload
	};
}

export function receiveAction(action, payload) {
	return {
		type: types.RECEIVE_ACTION,
		action: action,
		payload: payload
	};
}

export function receiveDataPoint(data_point) {
	return {
		type: types.RECEIVE_DATA_POINT,
		data_point: data_point
	};
}

export function receiveData(data) {
	return {
		type: types.RECEIVE_DATA,
		data: data
	};
}
