// Punto 1: Espacios Urbanos
class EspacioUrbano {
    var property valuadoEn 
    const property superficie 
    const property nombre
    var property tieneVallado  
    const property trabajosHeavies = []

    method esGrande() =
        superficie > 50 and
        self.condicionEspecifica()
    

    method condicionEspecifica() 

    method vallar() {
        tieneVallado = true
    }

    method esVerde()  

    method mejorarCesped() {
        valuadoEn += valuadoEn * 0.1
    }

    method esLimpiable()

    method limpiar() {
        valuadoEn += 5000
    }

    method agregarTrabajo(trabajo) {
        trabajosHeavies.add(trabajo)
    }

    method esDeUsoIntensivo() = trabajosHeavies.size() > 5
}

class Plaza inherits EspacioUrbano {
    const property canchas 

    override method condicionEspecifica() {
        canchas > 2
    }

    override method esVerde() = canchas == 0

    override method esLimpiable() = true
}

class Plazoleta inherits EspacioUrbano {
    const property procer

    override method condicionEspecifica() {
        procer == "San Martin"
    }
}

class Anfiteatrto inherits EspacioUrbano {
    const property capacidad

    override method condicionEspecifica() {
        capacidad > 500
    }

    override method esLimpiable() = self.esGrande()
}

class Multiespacio inherits EspacioUrbano {
    const property conformadoPor = []

    override method condicionEspecifica() {
        conformadoPor.all { espacio => espacio.esGrande() }
    }

    override method esVerde() = conformadoPor.size() > 3 
}

// Punto 2: Trabajadores
class Trabajador {
    var property profesion 
    method costoPorHora () = profesion.costoPorHora()

    method puedeTrabajar(espacioUrbano) = profesion.puedeTrabajar(espacioUrbano)

    method realizarTrabajo(espacioUrbano) {
        profesion.realizarTrabajo(espacioUrbano)
    }

    method duracionTrabajo(espacioUrbano) = profesion.duracionTrabajo(espacioUrbano) 

    method trabajoHeavy() = profesion.trabajoHeavy() 
}

class Profesion {
    var property costoPorHora 
    method trabajoHeavy(espacioUrbano) = costoPorHora > 10000
}
object cerrajero inherits Profesion (costoPorHora = 100) {
    method puedeTrabajar(espacioUrbano) = 
    if(espacioUrbano.tieneVallado())
        throw new DomainException(message = "Ya tiene vallado") 
    

    method realizarTrabajo(espacioUrbano){
        espacioUrbano.vallar()
    }

    method duracionTrabajo(espacioUrbano) = if(espacioUrbano.esGrande()) 5 else 3

    override method trabajoHeavy(espacioUrbano) = super(espacioUrbano) or self.duracionTrabajo(espacioUrbano) > 5
}

object jardinero inherits Profesion (costoPorHora = 2500) {

    method puedeTrabajar(espacioUrbano) = 
    if(!espacioUrbano.esVerde()) 
        throw new DomainException(message = "No es verde")
    
    method realizarTrabajo(espacioUrbano){
        espacioUrbano.mejorarCesped()
    }

    method duracionTrabajo(espacioUrbano) = espacioUrbano.superficie() / 10
}

object encargado inherits Profesion (costoPorHora = 100){

    method puedeTrabajar(espacioUrbano) = 
    if(!espacioUrbano.esLimpiable()) 
        throw new DomainException(message = "No se puede limpiar")
    
    method realizarTrabajo(espacioUrbano){
        espacioUrbano.limpiar()
    }

    method duracionTrabajo(espacioUrbano) = 8
}

// Punto 3: Trabajos

object calendario {
    method hoy() = new Date()
}
class Trabajo {
    var property fecha = calendario.hoy() 
    method validarTrabajo(trabajador, espacioUrbano) = trabajador.puedeTrabajar(espacioUrbano)

    method realizarTrabajo (trabajador, espacioUrbano) {
        //Falta validar trabajo
        trabajador.realizarTrabajo(espacioUrbano) 
        self.trabajoHeavy(trabajador, espacioUrbano)
    }

    method duracionTrabajo(trabajador, espacioUrbano) = trabajador.duracionTrabajo(espacioUrbano)
    method costoTrabajo (trabajador) = trabajador.costoPorHora()

    method trabajoHeavy(trabajador,espacioUrbano) {
        if(trabajador.trabajoHeavy())
            espacioUrbano.agregarTrabajo(self)
    }
}

