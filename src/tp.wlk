class Mago{
    const nombre 
    const poderInnato
    const objetosEquipados = []
    const resistenciaMagica
    var energiaMagica
    var categoria

    method nombre() = nombre
    method poderInnato() = poderInnato
    method resistenciaMagica() = resistenciaMagica
    method categoria() = categoria
    method energiaMagica() = energiaMagica

    method nuevaCategoria(nuevaCategoria){categoria = nuevaCategoria}
    method poderTotal() = (objetosEquipados.sum{ objetos => objetos.poder(self)}) * poderInnato

    method cantidadDeLetrasDeNombre() = nombre.length()
    method tieneNombrePar() = (nombre.length()).even()

   method desafiar(otroMago) {
    energiaMagica = (otroMago.categoria().esVencido(otroMago, self)) + energiaMagica
    otroMago.perderEnergiaMagica(otroMago.categoria().esVencido(otroMago, self)) 
    }

    method perderEnergiaMagica(cantidad){
        energiaMagica = energiaMagica - cantidad
    }
    
}

class ObjetosMagicos{

    method poderBase()

    method poder(mago)
}

class Varitas inherits ObjetosMagicos{
    const poderBase

    override method poderBase() = poderBase
    override method poder(mago){
        if (mago.tieneNombrePar()){
            return poderBase * 1.5
        }
        else return poderBase
    }
}

class Tunicas inherits ObjetosMagicos{
const rarezaTunica
var poderBase


    method rareza() = rarezaTunica
    override method poderBase() = poderBase
    override method poder(mago) = rarezaTunica.poder(self, mago)
       
}

class Rareza{
    const rareza

    method rareza() = rareza
}

object comun inherits Rareza( rareza = self){
    method poder(tunica, mago) = tunica.poderBase() +  2 * mago.resistenciaMagica()
}
object epica inherits Rareza( rareza = self){
    method poder(tunica, mago) = (tunica.poderBase() + 10) + 2 * mago.resistenciaMagica()
}

class Amuletos inherits ObjetosMagicos{

    override method poderBase() = 0
    override method poder(mago) = 200
}

object ojota inherits ObjetosMagicos{

    override method poderBase() = 0
    override method poder(mago) = mago.cantidadDeLetrasDeNombre() * 10
}

object aprendiz{
    method esVencido(mago, atacante){ 
        if (mago.resistenciaMagica() < atacante.poderTotal()) {
            mago.energiaMagica() - mago.energiaMagica() * 0.5} return mago.energiaMagica() * 0.5
        }
}

object veterano{
    method esVencido(mago, atacante){ 
        if (atacante.poderTotal() >= (mago.resistenciaMagica() * 1.5)) {
            mago.energiaMagica() - (mago.energiaMagica() * 0.25)} return mago.energiaMagica() * 0.25
    }
}

object inmortal{
    method esVencido(mago, atacante) = false 
}

class Gremio{
    const miembros = []
    var reservaDeEnergia

    method poderTotalGremio() = miembros.sum{miembros => miembros.poderTotal()}

    method reservaDeEnergia() = miembros.sum{miembros => miembros.energiaMagica()}

}