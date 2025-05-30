function atualizarRelogio() {
    const agora = new Date();

    // formatar horário
    let horas = agora.getHours();
    let minutos = agora.getMinutes();
    let segundos = agora.getSeconds();

    horas = horas < 10 ? '0' + horas : horas;
    minutos = minutos < 10 ? '0' + minutos : minutos;
    segundos = segundos < 10 ? '0' + segundos : segundos;

    const horarioFormatado = `${horas}:${minutos}:${segundos}`;
    document.getElementById('relogio').textContent = horarioFormatado;

    const dia = String(agora.getDate()).padStart(2, '0');
    const mes = String(agora.getMonth() + 1).padStart(2, '0'); 
    const ano = agora.getFullYear();
    const diaSemana = obterDiaDaSemana(agora.getDay());

    const dataFormatada = `${diaSemana}, ${dia}/${mes}/${ano}`;
    document.getElementById('data').textContent = dataFormatada;
}

function obterDiaDaSemana(diaIndex) {
    const dias = ["Domingo", "Segunda-feira", "Terça-feira", "Quarta-feira", "Quinta-feira", "Sexta-feira", "Sábado"];
    return dias[diaIndex];
}

atualizarRelogio();

setInterval(atualizarRelogio, 1000);