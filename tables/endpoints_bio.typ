#set table(fill: (_, y) => if y == 0 { rgb("#f6e3a8") })
#show table.cell.where(y: 0): set text(weight: "bold")
#import "../utils/todo.typ": todo

#figure(
  placement: auto,
  [
    #show regex("(GET|POST|DELETE)"): it => {
      let col = if (it.text == "GET") {
        rgb("#4caf50")
      } else if (it.text == "POST") {
        rgb("#f3bf21")
      } else if (it.text == "DELETE") {
        rgb("#f44336")
      } else {
        gray
      }
      let background-color = col.lighten(70%)
      let text-color = col.darken(40%)
      box(radius: 100%, inset: (y: 3pt, x: 6pt), fill: background-color, text(fill: text-color, raw(it.text)))
    }
    #show raw.where(block: false): it => {
      it.text
    }

    #table(
      columns: (auto, auto, auto),
      align: (center + horizon, center + horizon, left + horizon),

      [Endpoint], [Método], table.cell(align: center)[Descripción],

      [`/assembly/illumina`],
      [POST],
      [Iniciar ensamblaje de secuencias _Illumina_ con archivos FASTQ R1 y R2 con _SPAdes_.],

      [`/assembly/ont`],
      [POST],
      [Iniciar ensamblaje de secuencias _ONT_ con _Raven_ o _Flye_ a partir de un archivo FASTQ.],

      [`/annotation/bakta/upload`], [POST], [Ejecutar anotación _Bakta_ directamente desde un archivo FASTA subido.],

      [`/annotation/bakta/existing/{job_id}`],
      [POST],
      [Ejecutar anotación _Bakta_ sobre un ensamblaje completado previamente.],

      [`/jobs/{job_id}`], [GET], [Consultar estado actual de un proceso específico indicado por {job_id}.],

      [`/jobs`], [GET], [Listar todos los procesos con paginación.],

      [`/jobs/{job_id}/logs`], [GET], [Obtener logs detallados de ejecución de un proceso.],

      [`/jobs/{job_id}/retry`], [POST], [Reintentar un proceso fallido sin volver a subir los datos.],

      [`/jobs/{job_id}/cancel`], [POST], [Cancelar un proceso en estado pending o running.],

      [`/assembly/{job_id}/download`], [GET], [Descargar resultados del ensamblaje completado en formato FASTA.],

      [`/annotation/{job_id}/download`],
      [GET],
      [Descargar resultados de anotación en múltiples formatos o como ZIP o JSON.],

      [`/jobs/{job_id}`], [DELETE], [Eliminar un proceso específico y sus datos asociados.],

      [`/jobs/old/{days}`], [DELETE], [Eliminar procesos más antiguos que el número de días especificado.],

      [`/jobs`], [DELETE], [Eliminar todos los procesos y sus datos del sistema.],

      [`/health`], [GET], [Verificar estado de salud de la API, Redis y Celery.],

      [`/workers`], [GET], [Obtener información sobre workers de Celery activos y sus estadísticas.],

      [`/`], [GET], [Endpoint raíz con información general de la API y lista de endpoints disponibles.],
    )],
  caption: "Endpoints expuestos por la API del sistema bioinformático para la comunicación con el sistema web",
)<table:endpoints_bio>
