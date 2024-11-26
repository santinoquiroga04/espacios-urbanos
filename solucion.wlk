//Espacios urbanos
class EspacioUrbano {
    var property valuacion
    const property superficie 
    const property nombre
    const property tieneVallado 
    const property trabajosRealizados = [] 

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

// Trabajador y Profesion
class Trabajador {
    var property profesion 
}


object cerrajero {
    var property costoPorHora = 100

    method puedeRealizarlo(espacioUrbano) {
        !espacioUrbano.tieneVallado()
    }

    method realizarTabajo (espacioUrbano) {
        espacioUrbano.colocarVallado()
    }

    method duracionTrabajo (espacioUrbano) {
        if (espacioUrbano.esGrande()) 
            return 5
        else 
            return 3
    }
}

object jardinero{
    var property costoPorHora = 2500
    method puedeRealizarlo(espacioUrbano) {
        espacioUrbano.espacioVerde()
    }

    method realizarTabajo (espacioUrbano) {
        espacioUrbano.mejorarPasto()
    }

    method duracionTrabajo (espacioUrbano) {
        return espacioUrbano.superficie() * 0.1
    }
}

object encargado {
    var property costoPorHora = 100
    method puedeRealizarlo(espacioUrbano) {
        espacioUrbano.espacioLimpiable()
    }

    method realizarTabajo (espacioUrbano) {
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
    var property fecha
    var property duracion 
    const property trabajador
    const property espacioUrbano
    var property costo 

    method realizarTrabajo () {
        if(!trabajador.puedeRealizarlo(espacioUrbano))
            throw new DomainException (message = "El trabajador no puede realizar el trabajo")
        trabajador.realizarTabajo(espacioUrbano)
        costo = trabajador.costoPorHora() * duracion
        duracion = trabajador.duracionTrabajo(espacioUrbano)
        fecha = calendarioPosta.hoy()
        espacioUrbano.trabajosRealizados().add(self)
    }

    method esHeavy () {
        trabajador.trabajoHeavy()
    }
}

