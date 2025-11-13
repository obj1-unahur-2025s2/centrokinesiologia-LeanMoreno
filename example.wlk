class Paciente{
  var edad
  var fortalezaM
  var nivelDolor

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
}

class Magneto{
    method condicionUso(unPaciente) = true

    method efectoDeUsar(unPaciente){
        unPaciente.efectoMagneto()
    }
}

class Bicicleta{
    method condicionUso(unPaciente) = unPaciente.edad() > 8

    method efectoDeUsar(unPaciente){
        unPaciente.efectoBicicleta()
    }
}

class Minitramp{
    method condicionUso(unPaciente) = unPaciente.nivelDolor() < 20

    method efectoDeUsar(unPaciente){
        unPaciente.efectoMinitramp()
    }
}