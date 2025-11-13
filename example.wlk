class Paciente{
  var edad
  var fortalezaM
  var nivelDolor
  const rutinaAsignada = []

  method edad() = edad
  method fortalezaM() = fortalezaM
  method nivelDolor() = nivelDolor

  method puedeUsar(unAparato) = unAparato.condicionUso(self)

  method usarAparato(unAparato){
    if(self.puedeUsar(unAparato)){
        unAparato.efectoDeUsar(self)
    }
  }

  method efectoMagneto(){
    nivelDolor = (nivelDolor*0.90).max(0)
  }

  method efectoBicicleta(){
    nivelDolor = (nivelDolor - 4).max(0)
    fortalezaM = fortalezaM + 3
  }

  method efectoMinitramp(){
    fortalezaM = fortalezaM + (edad*0.10)
  }

  method puedeHacerRutina() = rutinaAsignada.all({a => self.puedeUsar(a)}) //Candidato a metodo abstracto

  method realizarRutina(){
    rutinaAsignada.forEach({a => self.usarAparato(a)})
  }

  method rutinaCompleta()
}

class PacienteResistente inherits Paciente{
    override method rutinaCompleta(){
        if(self.puedeHacerRutina()){
        self.realizarRutina()
        }
        fortalezaM += rutinaAsignada.size()
    }
}

class PacienteCaprichoso inherits Paciente{
    override method puedeHacerRutina() = super() and self.condicionExtra()

    method condicionExtra() = rutinaAsignada.any({a => a.color() == "rojo"})

    override method rutinaCompleta(){
        if(self.puedeHacerRutina()){
            self.realizarRutina()
            self.realizarRutina()
        }
    }
}

class PacienteRapRecu inherits Paciente{
    var bajaDelDolor = 3

    override method rutinaCompleta(){
        if(self.puedeHacerRutina()){
        self.realizarRutina()
        }
        nivelDolor = (nivelDolor - bajaDelDolor).max(0)
    }

    method cambiarBajaDelDolor(unValor){
        bajaDelDolor = unValor
    }
}

class Magneto{
    var color = "blanco"
    var imantacion = 800

    method color() = color

    method cambiarColor(unColor){
        color = unColor
    }

    method condicionUso(unPaciente) = true

    method efectoDeUsar(unPaciente){
        unPaciente.efectoMagneto()
        imantacion = (imantacion - 1).max(0)
    }

    method necesitaMantenimiento() =  imantacion < 100

    method hacerMantenimiento(){
        imantacion += 500
    }

    method mantenimiento(){
        if(self.necesitaMantenimiento()){
            self.hacerMantenimiento()
        }
    }
}

class Bicicleta{
    var color = "blanco"
    var cantTornillosFlojos = 0
    var cantPerdidasAceite = 0

    method color() = color

    method cambiarColor(unColor){
        color = unColor
    }

    method condicionUso(unPaciente) = unPaciente.edad() > 8

    method efectoDeUsar(unPaciente){
        self.consecuencia(unPaciente)
        unPaciente.efectoBicicleta()
    }

    method consecuencia(unPaciente){
        self.aflojarTornillos(unPaciente)
        self.perderAceite(unPaciente)
    }

    method aflojarTornillos(unPaciente){
        if(unPaciente.nivelDolor() > 30){
            cantTornillosFlojos += 1
        }
    }

    method perderAceite(unPaciente){
        if(unPaciente.nivelDolor() > 30 and unPaciente.edad().between(30, 50)){
            cantPerdidasAceite += 1
        }
    }

    method necesitaMantenimiento() = cantTornillosFlojos >= 10 || cantPerdidasAceite >= 5

    method hacerMantenimiento(){
        cantPerdidasAceite = 0
        cantTornillosFlojos = 0
    }

    method mantenimiento(){
        if(self.necesitaMantenimiento()){
            self.hacerMantenimiento()
        }
    }
}

class Minitramp{
    var color = "blanco"

    method color() = color

    method cambiarColor(unColor){
        color = unColor
    }

    method condicionUso(unPaciente) = unPaciente.nivelDolor() < 20

    method efectoDeUsar(unPaciente){
        unPaciente.efectoMinitramp()
    }

    method necesitaMantenimiento() = true
    method hacerMantenimiento() {}

    method mantenimiento(){
        if(self.necesitaMantenimiento()){
            self.hacerMantenimiento()
        }
    }
}

object centroKine{
    const aparatos = #{}
    const pacientes = #{}

    method colorAparatos() = aparatos.map({a => a.color()})

    method pacientesMenoresA8() = pacientes.filter({p => p.edad() < 8})

    method cantPacientesRutFallida() = pacientes.filter({p => !p.puedeHacerRutina()}).size()

    method estaEnOptimasCond() = aparatos.all({a => !a.necesitaMantenimiento()})

    method aparatosEnMalEstado() = aparatos.filter({a => a.necesitaMantenimiento()})

    method estaComplicado() = self.aparatosEnMalEstado().size() >= aparatos.size()/2

    method visitaDeTecnico() = aparatos.forEach({a => a.mantenimiento()})
}
