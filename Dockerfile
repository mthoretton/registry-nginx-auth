FROM openresty/openresty:trusty

RUN rm /usr/local/openresty/nginx/conf/nginx.conf

RUN mkdir /usr/local/openresty/nginx-jwt
RUN cd /usr/local/openresty/nginx-jwt \
  && curl -L -o ./nginx-jwt.tar.gz https://github.com/auth0/nginx-jwt/releases/download/v1.0.1/nginx-jwt.tar.gz \
  && tar xfv nginx-jwt.tar.gz \
  && rm nginx-jwt.tar.gz

COPY nginx.conf /usr/local/openresty/nginx/conf/nginx.conf
