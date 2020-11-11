class Minion{
	const armas = []
	var color = amarillo
	var bananas
	var participaciones=0
	
	method participaciones() = participaciones
	
	method noParticipo() = participaciones == 0
	
	method esPeligroso() = color.esPeligroso(self)
	
	method cantArmas() = armas.size()
	
	method agregarArma(unArma) = armas.add(unArma)
	
	method bananas() = bananas
	
	method tomarSuero(){
		color.absorberSuero(self)
	}
	
	method restarBanana(cant){
		bananas -= cant
	}
	
	method agregarBanana(cant){
		bananas += cant
	}
	
	method nivelConcentracion() = color.nivelConcentracion(self)
	
	method cambiarColor(unColor){
		color = unColor
	}
	
	method perderArmas(){
		armas.clear()
	}
	
	method armaMasPotente() = armas.max({unArma => unArma.potencia()})
	
	method tieneRayo(tipo) = armas.any({unArma => unArma.nombre() == ("rayo " + tipo)})

	method nivelConcentracionReq(cant) = self.nivelConcentracion() >= cant
	
	method bienAlimentado() = bananas> 100
	
	method sumarPart(){
		participaciones += 1
	}
}

/////////////////////////////////////////////////////////////////

object violeta{
	
	method esPeligroso(minion) = true
	
	method absorberSuero(minion){
		minion.restarBananas(1)
		minion.cambiarColor(amarillo)
	}
	
	method nivelConcentracion(minion) = minion.armaMasPotente().potencia() + minion.bananas()
}

object amarillo{
	
	method absorberSuero(minion){
		minion.perderArmas()
		minion.restarBananas(1)
		minion.cambiarColor(violeta)
	}
	
	method esPeligroso(minion) = minion.cantArmas() > 2
	
	method nivelConcentracion(minion) = minion.bananas()
}

///////////////////////////////////////////////////////////

class Arma{
	const nombre
	const potencia
	method potencia() = potencia
	method nombre() = nombre
}

/////////////////////////////////////////////////////////////////////////////

class Villano{
	const ciudad
	const minions =[]
	const rayoCongelante10 = new Arma (nombre = "rayo congelante", potencia = 10)
	
	method nuevoMinion(){
		const minion = new Minion(color = amarillo, bananas = 5, armas = [rayoCongelante10])
		minions.add(minion)
	}
	
	method otorgarArmaA(minion,arma){
		minion.agregarArma(arma)
	}
	
	method alimentarA(minion,cant){
		minion.agregarBanana(cant)
	}
	
	method nivelDeConcentracion(minion) = minion.nivelDeConcentracion()
	
	method esPeligroso(minion) = minion.esPeligroso()
	
	method planificarMaldad(maldad){
		const capacitadosM = self.estanCapacitados(maldad)
		self.verificarPlanificacion(capacitadosM)
		self.realizarMaldad(maldad,capacitadosM)
	}
	
	method verificarPlanificacion(capacitados){
		if(not capacitados.isEmpty()){
			self.error("NO HAY MINIONS ASIGNADOS")
		}
	}
	
	method estanCapacitados(maldad) = minions.filter({unMinion => maldad.cumpleCriterio(unMinion)})

	method realizarMaldad(maldad,minionsCap){
		maldad.realizar(ciudad,self)
		minions.forEach({unMinion => unMinion.sumarPart()})
		}
	
	method otorgarRayoCongelante() = minions.forEach({unMinion => unMinion.agregarArma(rayoCongelante10)})
	
	method administrarSuero() = minions.forEach({unMinion => unMinion.tomarSuero()})
	
	method darBananas(cant) = minions.forEach({unMinion => unMinion.agregarBanana(cant)})
	
	method minionMasUtil() = minions.max({unMinion => unMinion.participaciones()})
	
	method minionsInutiles() = minions.filter({unM => unM.noParticipo()})
}

///////////////////////////////////////////////////////////////////////////////////////////
object congelar{
	var nivelConcentracion = 500
	
	method cumpleCriterio(minion) = minion.tieneRayo("congelante") && minion.nivelConcentracionReq(nivelConcentracion)

	method realizar(ciudad,villano){
		villano.darBananas(10)
		ciudad.disminuirTemp(30)
	}
}

class Robar{
	const objetivo
	method cumpleCriterio(minion) = minion.esPeligroso() && objetivo.cumpleCriterio(minion)

	method realizar(ciudad,villano){
		ciudad.perderObjeto(objetivo)
		objetivo.robar(villano)
	}
}

class Piramide{
	const altura
	const conParticular = altura/2
	
	method cumpleCriterio(minion) = minion.nivelConcentracionReq(conParticular)
	
	method robar(villano){
		villano.darBananas(10)
	}
	
}

object laLuna{
	method cumpleCriterio(minion) = minion.tieneRayo("encongedor")
	
	method robar(villano){
		villano.otorgarRayoCongelante()
	}
}

object sueroMutante{
	method cumpleCriterio(minion) = minion.bienAlimentado() && minion.nivelConcentracionReq(23)
	
	method robar(villano){
		villano.administrarSuero()
	}
}

////////////////////////////////////////////////////////////////

class Ciudad{
	var grados
	const objetosARobar = []
	
	method disminuirTemp(cantidad){
		grados -= cantidad
	}
	
	method perderObjeto(algo) = objetosARobar.remove(algo)
}

/////////////////////////////////////////////////////////////////////////////////////////////


