// Punto 1: Espacios Urbanos
class EspacioUrbano {
    var property valuadoEn 
    const property superficie 
    const property nombre
    var property tieneVallado  
    const property trabajos = []

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
        trabajos.add(trabajo)
    }

    method esDeUsoIntensivo() = trabajos.any { trabajo => trabajo.esHeavy() and trabajo.esDelUltimoMes() } > 5
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

    method realizarTrabajo(espacioUrbano) {
        profesion.realizarTrabajo(espacioUrbano)
    }

    method duracionTrabajo(espacioUrbano) = profesion.duracionTrabajo(espacioUrbano) 

    method trabajoHeavy() = profesion.trabajoHeavy() 
}


object cerrajero {
    var property costoPorHora = 100  
    
    method realizarTrabajo(espacioUrbano){
        if(espacioUrbano.tieneVallado()){
            throw new DomainException(message = "Ya tiene vallado") 
        }
        espacioUrbano.vallar()
    }

    method duracionTrabajo(espacioUrbano) = if(espacioUrbano.esGrande()) 5 else 3
    method trabajoHeavy(espacioUrbano) = costoPorHora > 10000 or self.duracionTrabajo(espacioUrbano) > 5
}

object jardinero {
    var property costoPorHora = 2500
    
    method realizarTrabajo(espacioUrbano){
        if(!espacioUrbano.esVerde()){
            throw new DomainException(message = "No es verde")
        } 
        espacioUrbano.mejorarCesped()
    }

    method duracionTrabajo(espacioUrbano) = espacioUrbano.superficie() / 10

    method trabajoHeavy(espacioUrbano) = costoPorHora > 10000
}

object encargado{
    var property costoPorHora = 100
    method realizarTrabajo(espacioUrbano){
        if(!espacioUrbano.esLimpiable()){
            throw new DomainException(message = "No se puede limpiar")
        }
        espacioUrbano.limpiar()
    }

    method duracionTrabajo(espacioUrbano) = 8
}

// Punto 3: Trabajos

object calendario {
    const property hoy = new Date()
    const property haceUnMes = hoy.minusMonths(1) 
}
class Trabajo {
    var property fecha = calendario.hoy() 
    method validarTrabajo(trabajador, espacioUrbano) = trabajador.puedeTrabajar(espacioUrbano)

    method realizarTrabajo (trabajador, espacioUrbano) {
        trabajador.realizarTrabajo(espacioUrbano) 
        espacioUrbano.agregarTrabajo(self)
    }

    method duracionTrabajo(trabajador, espacioUrbano) = trabajador.duracionTrabajo(espacioUrbano)
    method esDelUltimoMes() = fecha > calendario.haceUnMes()
    method esHeavy(trabajador, espacioUrbano) = trabajador.trabajoHeavy(espacioUrbano)
    method costoTrabajo (trabajador,espacioUrbano) = trabajador.costoPorHora() * self.duracionTrabajo(trabajador, espacioUrbano)
}

