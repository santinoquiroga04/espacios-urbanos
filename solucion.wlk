class EspacioUrbano {
    var property valuacion
    const property superficie 
    const property nombre
    const property tieneVallado 

    method esGrande () {
        self.superficie() > 50 and
        self.condicionEspecifica()
    }

    method condicionEspecifica ()

    method colocarVallado () {
        self.tieneVallado() 
    }

    method espacioVerde () 

    method mejorarPasto () {
        valuacion = valuacion + (valuacion + 0.1)
    }

    method espacioLimpiable ()

    method limpiar () {
        valuacion = valuacion + 5000
    }

    method espacioDeUsoIntensivo (trabajo) {
        trabajo.esHeavy()
    }
}

class Plaza inherits EspacioUrbano {
    const property cantidadCanchas

    override method condicionEspecifica () {
        self.cantidadCanchas() > 2
    }

    override method espacioVerde () {
        self.cantidadCanchas() == 0
    }

    override method espacioLimpiable () {
        self.esGrande()
    }
}

class Plazoleta inherits EspacioUrbano{
    const property procerHomenajeado

    override method condicionEspecifica () {
        self.procerHomenajeado() == "San Martin" and
        self.tieneVallado()
    } 
}

class Anfiteatro inherits EspacioUrbano{
    const property capacidad

    override method condicionEspecifica () {
        self.capacidad() > 500
    }
}

class Multiespacio inherits EspacioUrbano{
    const property conformadoPor = []

    override method condicionEspecifica () {
        conformadoPor.all { espacio => espacio.esGrande() }
    }

    override method espacioVerde () {
        conformadoPor.size() > 3
    }

    override method espacioLimpiable () {
        self.esGrande()
    }
}

class Trabajador {
    var property profesion 
}

class Profesion {
    var property costoPorHora  

    method trabajoHeavy (espacioUrbano){
        costoPorHora > 10000
    }
}
object cerrajero inherits Profesion (costoPorHora = 2500) {

    method trabajarEspacio(espacioUrbano) {
        if (!espacioUrbano.tieneVallado()) 
            throw new DomainException(message = "El espacio urbano ya tiene vallado")
        else 
            espacioUrbano.colocarVallado()
    }

    method duracionTrabajo (espacioUrbano) {
        if (espacioUrbano.esGrande()) 
            return 5
        else 
            return 3
    }

    override method trabajoHeavy (espacioUrbano){
        super(espacioUrbano) or self.duracionTrabajo(espacioUrbano) > 5
    }
}

object jardinero inherits Profesion (costoPorHora = 2500){
    
    method trabajarEspacio(espacioUrbano) {
        if (!espacioUrbano.espacioVerde()) 
            throw new DomainException(message = "El espacio urbano no es un espacio verde")
        else 
            espacioUrbano.mejorarPasto()
    }

    method duracionTrabajo (espacioUrbano) {
        return espacioUrbano.superficie() * 0.1
    }
}

object encargado inherits Profesion (costoPorHora = 100){

    method trabajarEspacio(espacioUrbano) {
        if (!espacioUrbano.espacioLimpiable()) 
            throw new DomainException(message = "El espacio urbano no es limpiable")
        else 
            espacioUrbano.limpiar()
    }

    method duracionTrabajo () {
        return 8
    }
}

// wollok:solucion> const tito = new Trabajador (profesion = cerrajero)
// ✓
// wollok:solucion> tito.profesion(jardinero)
// ✓

object calendarioPosta { 
    method hoy() = new Date()
}

class Trabajo {
    var property fecha = calendarioPosta.hoy()
    var property duracion
    const property trabajador
    const property espacioUrbano
    var property costo 

    method realizarTrabajo () {
        trabajador.trabajarEspacio(espacioUrbano)
    }

    method calcularDuracion () {
        duracion = trabajador.duracionTrabajo(espacioUrbano)
    }
    method calcularCosto () {
        costo = trabajador.costoPorHora() * duracion
    }

    method esHeavy () {
        trabajador.trabajoHeavy()
    }
}

