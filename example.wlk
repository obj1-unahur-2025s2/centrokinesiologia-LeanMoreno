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

  method rutinaCompleta(){
    if(self.puedeHacerRutina()){
        self.realizarRutina()
    }
  }
}

class PacienteResistente inherits Paciente{
    override method rutinaCompleta(){
        super()
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
        super()
        nivelDolor = (nivelDolor - bajaDelDolor).max(0)
    }

    method cambiarBajaDelDolor(unValor){
        bajaDelDolor = unValor
    }
}

class Magneto{
    var color = "blanco"

    method color() = color

    method cambiarColor(unColor){
        color = unColor
    }

    method condicionUso(unPaciente) = true

    method efectoDeUsar(unPaciente){
        unPaciente.efectoMagneto()
    }
}

class Bicicleta{
    var color = "blanco"

    method color() = color

    method cambiarColor(unColor){
        color = unColor
    }

    method condicionUso(unPaciente) = unPaciente.edad() > 8

    method efectoDeUsar(unPaciente){
        unPaciente.efectoBicicleta()
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
}