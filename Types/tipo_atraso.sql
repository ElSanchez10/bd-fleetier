-- En qué etapa se atrasaron las órdenes: al despacharlas o al armarlas.
create type tipo_atraso as enum ('despacho', 'picking');
