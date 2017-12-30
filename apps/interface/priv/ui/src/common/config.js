export const host = () => {
  if(process.env.NODE_ENV == 'development'){
    return 'ws://localhost:8084/ws';
  }else{
    return null;
  }
}

export const num_data_points = 120;
