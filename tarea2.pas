procedure darUnPaso(var balin: TBalin);
begin
    with balin do
    begin
        pelota.posicion.x := pelota.posicion.x + velocidad.Vx;
        pelota.posicion.y := pelota.posicion.y + velocidad.Vy;
        
        if ((pelota.posicion.x + RADIO) > ANCHO) OR (pelota.posicion.x < RADIO) then
            velocidad.Vx := velocidad.Vx * -1;
        if ((pelota.posicion.y + RADIO) > ALTO) then
            velocidad.Vy := velocidad.Vy * -1;
    end;
end;

function calcularDistancia(pos1, pos2 : TPelota): real;
begin
    calcularDistancia := sqrt(sqr(pos1.x - pos2.x) + sqr(pos1.y - pos2.y))
end;

function estanChocando(p1, p2: TPelota): boolean;
var 
    distancia : real;
begin
    distancia := calcularDistancia(p1.posicion, p2.posicion);
    estanChocando := distancia < (RADIO * 2)
end;

function esFrontera(indicePelota: TIndicePelota; zonaPelotas: TZonaPelotas): boolean;
var tieneVecinos : boolean;
begin 
    tieneVecinos := false;
    if zonapelotas[indicePelota.i, indicePelota.j].ocupada = true then
        if (indicePelota.i = 1) OR (indicePelota.i = CANT_FILAS) OR (indicePelota.j = 1) OR (indicePelota.i = CANT_COLUMNAS)
            with indicePelota do
                tieneVecinos := zonaPelotas[i + 1, j + 1].ocupada OR zonaPelotas[i + 1, j - 1].ocupada OR zonaPelotas[i - 1, j + 1].ocupada OR zonaPelotas[i - 1, j - 1].ocupada;
    esFrontera := tieneVecinos;
end;

procedure obtenerFrontera(zonaPelotas: TZonaPelotas; var frontera: TSecPelotas);
var indicesPelotas : TIndicePelota;
    esFrontera : boolean;
    contador : int;
begin
    frontera.tope := 0;
    for indicePelotas.i := 1 to CANT_COLUMNAS do
        for indicePelotas.j := 1 to CANT_FILAS do
        begin
            esFrontera := esFrontera(indicePelotas, zonaPelotas);
            if esFrontera = true then
                with frontera do
                begin
                    sec[tope] := indicePelotas;
                    tope := tope + 1
                end;
        end;
end;

procedure obtenerPelotaConIndice(indice : TIndicePelota, zona : TZonaPelotas; var pelotaDevuelta : TPelota);
var 
    i, iAux : RangoFilas;
    j, jAux : RangoColumnas;
    encontrado : boolean;
begin

    iAux := 1;
    jAux := 1;

    for i := 1 to CANT_FILAS do
        for j := 1 to CANT_COLUMNAS do
            if indice.i = i && indice.j = j then
            begin
                iAux := i;
                jAux := j;
            end;
        
    pelotaDevuelta := zona[iAux, jAux].pelota 
end;

procedure disparar(b: TBalin; frontera: TSecPelotas; zona:TZonaPelotas; var indicePelota: TIndicePelota; var chocaFrontera: boolean);
{precondicion, todos los indices de la frontera estan ocupados}
type
    rangoCantPelotas : 1..CANT_PELOTAS;
var 
    chocan : boolean;
    i : rangoCantPelotas;
    pelotaDevuelta : TPelota;
begin
    chocan := false;
    darUnPaso(b);

    while (! chocan) && (! b.pelota.posicion.y - RADIO < 1) do
    begin
        i := 1;
        darUnPaso(b);
        for i to frontera.tope do
        begin
            obtenerPelotaConIndice(frontera.sec[i], zona, pelotaDevuelta);
            chocan := estanChocando(b.pelota, pelotaDevuelta);
            if chocan && pelotaDevuelta.color = b.pelota.color then
                indicePelota := frontera.sec[i];
                chocan := true
        end;
        darUnPaso(b);
    end;

    chocaFrontera := chocan
end;

procedure eliminarPelotas(var zonaPelotas: TZonaPelotas; aEliminar: TSecPelotas);
var i,j, k : integer;
begin
    for i := 1 to CANT_FILAS do
        for j := 1 to CANT_COLUMNAS do
            for k := 1 to aEliminar.tope do
                if (zonaPelotas[i,j].ocupada) AND (aEliminar.sec[k].i = i) AND (aEliminar.sec[k].j = j)  then
                    zonaPelotas[i,j].ocupada := false;
end;

function esZonaVacia(zonaPelotas: TZonaPelotas): boolean;
var 
    vacia : boolean;
    i : RangoFilas + 1;
    j : RangoColumnas;
begin
    i := 1;
    vacia := true;

    while vacia && i <= RangoFilas do
        for j := 1 to CANT_COLUMNAS do
            if zonaPelotas[i, j].ocupada then
                vacia := false;
        i := i + 1
    end;
    
    esZonaVacia := vacia
end;