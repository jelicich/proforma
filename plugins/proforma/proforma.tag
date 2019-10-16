<proforma>
	<div if="{items}">
		<table class="proforma-header">
			<tr>
				<td>
					<img src="http://shmit.com.ar/assets/logos/shm-logo-256.png">
				</td>
				<td>
					<ul>
						<li>
							Tel: +54 11 5350-6037
						</li>
						<li>
							www.shmit.com.ar
						</li>
						<li>
							contacto@shmit.com.ar
						</li>
					</ul>
				</td>
				<td>	
					<ul>
						<li>Pedido #000517</li>
						<li>Fecha 10/10/2019</li>
						<li>Hora 16:50:18</li>
					</ul>
				</td>
			</tr>
		</table>

		<table class="proforma-client-info">
			<tr>
				<td>
					<p class="client-name"><span>Cliente</span> CLIENTE</p>
					<p class="client-address"><span>Direccion de la empresa</span> DIRECCION</p>
					<p class="client-condition"><span>Condicion de venta:</span> Condicion</p>
				</td>
			</tr>
		</table>

		<table class="proforma-items">
			<thead>
				<td>Articulo</td>
				<td>Descripcion</td>
				<td>Cantidad</td>
				<td>IVA</td>
				<td>Precio</td>
				<td>Subtotal</td>
			</thead>
			<tr each="{item in items}">
				<td>{item.sku}</td>
				<td>{item.descripcion}</td>
				<td>{item.cantidad}</td>
				<td>{item.ivaPorcentaje}</td>
				<td>{item.precioUnitario}</td>
				<td>{item.precioCantidad}</td>
			</tr>
		</table>

		<table class="proforma-total">
			<tr>
				<td>
					<p class="disclaimer">
						El siguiente presupuesto tiene una vigencia de cinco (5) días.
	Los precios están expresados en dolares y convertidos a pesos para referencia (TC).
	Este documento no garantiza el abastecimiento de lo presupuestado ni genera reserva
	de stock
					</p>
				</td>
				<td>
					
					<table class="taxes-summary">
						<tr>
							<td>Subtotal</td>
							<td></td>
							<td>{subtotal.pesos}</td>
							<td>{subtotal.usd}</td>
						</tr>

						<tr>
							<td>IVA</td>
							<td>10.50%</td>
							<td>{iva.pesos['10.50']}</td>
							<td>{iva.usd['10.50']}</td>
						</tr>

						<tr>
							<td>IVA</td>
							<td>21.00%</td>
							<td>{iva.pesos['21.00']}</td>
							<td>{iva.usd['21.00']}</td>
						</tr>

						<tr>
							<td>TC</td>
							<td>{TC}</td>
							<td></td>
							<td></td>
						</tr>

						<tr>
							<td>TOTAL</td>
							<td></td>
							<td>{total.pesos}</td>
							<td>{total.usd}</td>
						</tr>
					</table>

				</td>
			</tr>
		</table>
	</div>
		

	<script>
		this.TC = 59.7;
		this.items = null;

		this.on('mount', function(argument) {
			this.items = proformify.data;
			this.subtotal = this.calculateSubtotal();
			this.iva = this.calculateIVA();
			this.total = this.calculateTotal();
			this.update();
		})

		this.calculateSubtotal = function() {
			var subtotal = {usd: 0, pesos: 0};
			for(var i = 0; i < this.items.length; i++) {
				subtotal.usd = subtotal.usd + accounting.unformat(this.items[i].precioCantidad);
			}
			subtotal.pesos = formatCurrency(subtotal.usd * this.TC, '$');
			subtotal.usd = formatCurrency(subtotal.usd);

			return subtotal;
		}

		this.calculateIVA = function() {
			var iva = {
				usd: {
					'10.50': 0,
					'21.00': 0
				},
				pesos: {
					'10.50': 0,
					'21.00': 0
				}
			}
			for(var i = 0; i < this.items.length; i++) {
				if(this.items[i].ivaPorcentaje == "10.50%") {
					iva.usd['10.50'] += accounting.unformat(this.items[i].ivaUSD);
				} else if(this.items[i].ivaPorcentaje == '21.00%') {
					iva.usd['21.00'] += accounting.unformat(this.items[i].ivaUSD);
				}
			}
			iva.pesos['10.50'] = formatCurrency(iva.usd['10.50'] * this.TC, '$');
			iva.pesos['21.00'] = formatCurrency(iva.usd['21.00'] * this.TC, '$');
			iva.usd['10.50'] = formatCurrency(iva.usd['10.50']);
			iva.usd['21.00'] = formatCurrency(iva.usd['21.00']);

			return iva;
		}

		this.calculateTotal = function() {
			var usd = accounting.unformat(this.subtotal.usd) + accounting.unformat(this.iva.usd['10.50']) + accounting.unformat(this.iva.usd['21.00']);
			var pesos = accounting.unformat(this.subtotal.pesos) + accounting.unformat(this.iva.pesos['10.50']) + accounting.unformat(this.iva.pesos['21.00']);
			var total = {
				usd: formatCurrency(usd), 
				pesos: formatCurrency(pesos, '$'),
			};
			return total;
		}

		function formatCurrency(number, currency) {
			var currency = currency || 'USD';
			return accounting.formatMoney(number, currency+' ', 2, ",", ".");
		}
	</script>
</proforma>