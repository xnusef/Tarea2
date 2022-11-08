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
    calcularDistancia := sqrt(sqr(pos1.posicion.x - pos2.posicion.x) + sqr(pos1.posicion.y - pos2.posicion.y))
end;

function estanChocando(p1, p2: TPelota): boolean;
var 
    distancia : real;
begin
    distancia := calcularDistancia(p1, p2);
    estanChocando := distancia < (RADIO * 2)
end;

function esFrontera(indicePelota: TIndicePelota; zonaPelotas: TZonaPelotas): boolean;
var frontera : boolean;
    k : integer;
begin
    frontera := false;
    if (zonaPelotas[indicePelota.i, indicePelota.j].ocupada) then
    begin
        frontera := (indicePelota.i = 1) OR (indicePelota.i = CANT_FILAS) OR (indicePelota.j = 1) OR (indicePelota.j = CANT_COLUMNAS);
        if not (frontera) then
            with indicePelota do
            begin
                for k := -1 to 1 do
                    if (k <> 0) AND ((i + k) >= 1) AND ((i + k) <= CANT_FILAS) then
                        frontera := frontera OR not (zonaPelotas[i + k, j].ocupada);
                for k := -1 to 1 do
                    if (k <> 0) AND ((j + k) >= 1) AND ((j + k) <= CANT_COLUMNAS) then
                        frontera := frontera OR not (zonaPelotas[i, j + k].ocupada);
            end;  
    end;  

    esFrontera := frontera;
end;

procedure obtenerFrontera(zonaPelotas: TZonaPelotas; var frontera: TSecPelotas);
var indicePelotas : TIndicePelota;
    esFronteraFlag : boolean;
    // contador : integer;
    i,j : integer;
begin
    frontera.tope := 0;
    for i := 1 to CANT_COLUMNAS do
        for j := 1 to CANT_FILAS do
        begin
            indicePelotas.i := i;
            indicePelotas.j := j;
            esFronteraFlag := esFrontera(indicePelotas, zonaPelotas);
            if esFronteraFlag = true then
                with frontera do
                begin
                    if (tope + 1) <= CANT_PELOTAS then
                    begin
                        tope := tope + 1;
                        sec[tope] := indicePelotas;
                    end;
                end;
        end;
end;


procedure obtenerPelotaConIndice(indice : TIndicePelota ; zona : TZonaPelotas; var pelotaDevuelta : TPelota);
var 
    i, iAux : RangoFilas;
    j, jAux : RangoColumnas;
begin

    iAux := 1;
    jAux := 1;

    for i := 1 to CANT_FILAS do
        for j := 1 to CANT_COLUMNAS do
            if (indice.i = i) AND (indice.j = j) then
            begin
                iAux := i;
                jAux := j;
            end;
        
    pelotaDevuelta := zona[iAux, jAux].pelota 
end;

procedure disparar(b: TBalin; frontera: TSecPelotas; zona:TZonaPelotas; var indicePelota: TIndicePelota; var chocaFrontera: boolean);
type
    rangoCantPelotas = 1..CANT_PELOTAS;
var 
    chocan, chocaron, chocanMismoColor: boolean;
    i : rangoCantPelotas;
    pelotaDevuelta : TPelota;
begin
    chocan := false;
    chocaron := false;
    chocanMismoColor := false;

    repeat;        
        darUnPaso(b);
        for i := 1 to frontera.tope do
        begin
            obtenerPelotaConIndice(frontera.sec[i], zona, pelotaDevuelta);
            chocan := (estanChocando(b.pelota, pelotaDevuelta));
            if chocan AND (b.pelota.color = pelotaDevuelta.color) AND not(chocaron) then
            begin
                indicePelota := frontera.sec[i];
                chocanMismoColor := true   
            end;    
            chocaron := chocan OR chocaron;
        end;        
    until (chocaron) OR (b.pelota.posicion.y - RADIO < 1);
    
    chocaFrontera := chocanMismoColor;
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
    i : 1..(CANT_FILAS+1);
    j : RangoColumnas;
begin
    i := 1;
    vacia := true;
    repeat
        for j := 1 to CANT_COLUMNAS do
            if zonaPelotas[i, j].ocupada then
                vacia := false;
        i := i + 1
    until (not (vacia)) OR (i > CANT_FILAS);
    
    esZonaVacia := vacia
end;