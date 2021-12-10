
create table Usuario (
    
    rut text primary key not null,
    RegistradoS_N boolean,
    nombre text, 
    apellido text,
    contraseña varchar(20),
    cuidad text,
    comuna text,
    calle text,
    numero text
);
create table categoria(
    id_categoria int primary key not null,
    nombre text ,
    descripcion text ,
);
create table empresa(
    id_empresa int primary key not null,
    nombre text,
    direccion text,
    correo text,
    telefono text,
    n_envios int 
);
create table compra (
    id_compra serial not null primary key,
    id_transporte int ,
    total_compra int,
    direccion_retiro text,
    direccion_envio text,
    foreign key (id_transporte) references empresa(id_empresa)
);
create table producto (
    id_producto int primary key not null,
    id_categoria int, 
    descuento int,
    cantidad int,
    precio int,
    color text,
    descripcion text,
    nombre text,
    foreign key (id_categoria) references categoria(id_categoria)
);
create table realiza (
    rut text,
    id_compra int ,
    fecha_compra datetime,
    foreign key (rut) references Usuario(rut),
    foreign key (id_compra) references compra(id_compra)
);
create table detalle (
    id_producto int,
    id_compra int, 
    cantidad int,
    foreign key (id_producto) references producto(id_producto),
    foreign key (id_compra) references compra(id_compra)
);
create table provee (
    rut text,
    id_producto int,
    foreign key (rut) references Usuario_registrado(rut),
    foreign key (id_producto) references producto(id_producto)
);

