// ------------------------------------------- Magos y objetos magicos punto 1 -----------------------------------------------
class Mago{
    const property nombre 
    const property poderInnato
    const objetosEquipados = []
    const property resistenciaMagica
    var property energiaMagica
    var property categoria


    method nuevaCategoria(nuevaCategoria){categoria = nuevaCategoria}
    method poderTotal() = (objetosEquipados.sum{ objetos => objetos.poder(self)}) * poderInnato

    method cantidadDeLetrasDeNombre() = nombre.length()
    method tieneNombrePar() = (nombre.length()).even()

    method vence(atacante) = categoria.condicionParaSerVencido(atacante, self)

    method ganarleA(otroMago){
        self.robarPuntos(otroMago.puntosPerdidos())
        otroMago.perdio()
    }

    method desafiar(otroMago){ //tambien funciona con un gremio
        if(self.vence(otroMago)){
           self.ganarleA(otroMago)
        } // sino no pasa nada porque no se puede vencer
    }

    method robarPuntos(cantidad){
        energiaMagica += cantidad
    }

    method perderPuntos(cantidad){
        energiaMagica -= cantidad.max(0)
    }
    method puntosPerdidos() = categoria.puntosPerdidos(self)

    method perdio(){
        self.perderPuntos(self.puntosPerdidos())
    }

    method esMago() = true
}

class ObjetosMagicos{

    method poder(mago)
}

class Varitas inherits ObjetosMagicos{
    const property poderBase

    override method poder(mago){
        if (mago.tieneNombrePar()){
            return poderBase * 1.5
        }
        else return poderBase
    }
}

class Tunicas inherits ObjetosMagicos{
const property rarezaTunica
const property poderBase

    override method poder(mago) = rarezaTunica.poder(self) +  2 * mago.resistenciaMagica()
       
}


object comun {
    method poder(tunica) = tunica.poderBase()
}
object epica {
    method poder(tunica) = (tunica.poderBase() + 10) 
}

class Amuletos inherits ObjetosMagicos{

    override method poder(mago) = 200
}

object ojota inherits ObjetosMagicos{

    override method poder(mago) = mago.cantidadDeLetrasDeNombre() * 10
}

// ------------------------------------------- Magos y objetos magicos punto 2 -----------------------------------------------

object aprendiz{
    method condicionParaSerVencido(atacante, mago) = mago.resistenciaMagica() < atacante.poderTotal()
    method puntosPerdidos(mago) = mago.energiaMagica() / 2

}

object veterano{
    method condicionParaSerVencido(atacante, mago) = atacante.poderTotal() >= (mago.resistenciaMagica() * 1.5)
    method puntosPerdidos(mago) = mago.energiaMagica() * 0.25
}

object inmortal{
    method condicionParaSerVencido(atacante, mago) = false 
    method puntosPerdidos(mago) = 0
}

// ------------------------------------------- Gremios punto 1 -----------------------------------------------

class Gremio{
    var property lider = self.liderDelGremio()
    var property miembros 

     method initialize() {
        if(miembros.size() < 2){
            throw new Exception(message = "Un gremio debe tener al menos dos miembros")
        }
    }

    method esMago() = false

    method poderTotalGremio() = miembros.sum{miembros => miembros.poderTotal()}

    method reservaDeEnergia() = miembros.sum{miembros => miembros.energiaMagica()}

    method liderDelGremio(){ 
        const miembroDeMasPoder = miembros.max{miembro => miembro.poderTotal()}
        if (miembroDeMasPoder.esMago()){return miembroDeMasPoder}
        else miembroDeMasPoder.liderDelGremio()}

    method resistenciaMagica() = miembros.sum{ miembro => miembro.resistenciaMagica()} + lider.resistenciaMagica()

     method desafiar(otroGremio){ //tambien funciona con un miembro, no tiene porque ser otro gremio
        if(self.vence(otroGremio)){
            self.ganarleA(otroGremio)
        }
    }

    method vence(otroGremio) = self.esVencidoPor(otroGremio)

    method esVencidoPor(atacante) = atacante.poderTotal() > self.resistenciaMagica()

    method ganarleA(otroGremio){
        self.darlePuntosAlLider(otroGremio.puntosPerdidos())
        otroGremio.perdio()
    }

    method todoElGremioPierdePuntos(){
     miembros.foreach{miembro => miembro.perderPuntos(miembro.puntosPerdidos())}
    }

    method darlePuntosAlLider(cantidad){
        lider.robarPuntos(cantidad)
    }

    method puntosPerdidos() = miembros.sum{miembro => miembro.puntosPerdidos()}


    
}
