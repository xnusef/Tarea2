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

procedure disparar(b: TBalin; frontera: TSecPelotas; zona:TZonaPelotas; var indicePelota: TIndicePelota; var chocaFrontera: boolean);
begin
    
end;

procedure eliminarPelotas(var zonaPelotas: TZonaPelotas; aEliminar: TSecPelotas);
begin
    
end;

function esZonaVacia(zonaPelotas: TZonaPelotas): boolean;
begin
    
end;