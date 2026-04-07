package com.vaibhav.kundli.ui.kundli

import android.content.Context
import android.graphics.Canvas
import android.graphics.Color
import android.graphics.Paint
import android.graphics.Path
import android.util.AttributeSet
import android.view.View
import com.vaibhav.kundli.domain.model.PlanetPosition
import com.vaibhav.kundli.util.Constants

class KundliChartView @JvmOverloads constructor(
    context: Context,
    attrs: AttributeSet? = null,
    defStyleAttr: Int = 0
) : View(context, attrs, defStyleAttr) {

    private val linePaint = Paint(Paint.ANTI_ALIAS_FLAG).apply {
        color = Color.parseColor("#FFD700")
        strokeWidth = 2f
        style = Paint.Style.STROKE
    }

    private val housePaint = Paint(Paint.ANTI_ALIAS_FLAG).apply {
        color = Color.parseColor("#FFD70030")
        style = Paint.Style.FILL
    }

    private val houseNumPaint = Paint(Paint.ANTI_ALIAS_FLAG).apply {
        color = Color.parseColor("#FFD700")
        textSize = 28f
        textAlign = Paint.Align.CENTER
    }

    private val planetPaint = Paint(Paint.ANTI_ALIAS_FLAG).apply {
        color = Color.parseColor("#FF6B00")
        textSize = 24f
        textAlign = Paint.Align.CENTER
    }

    private val lagnaIndicatorPaint = Paint(Paint.ANTI_ALIAS_FLAG).apply {
        color = Color.parseColor("#00C853")
        textSize = 22f
        textAlign = Paint.Align.CENTER
    }

    var planets: List<PlanetPosition> = emptyList()
        set(value) { field = value; invalidate() }

    var lagnaRashi: Int = 0
        set(value) { field = value; invalidate() }

    // North Indian style house layout - house numbers in fixed positions
    // Center diamond surrounded by 12 houses
    // House positions (center x,y) as fractions of view size
    // North Indian: 1 at top-center, going clockwise
    private val housePositions = arrayOf(
        floatArrayOf(0.5f, 0.17f),  // House 1  - top center
        floatArrayOf(0.75f, 0.17f), // House 2  - top right
        floatArrayOf(0.83f, 0.5f),  // House 3  - right
        floatArrayOf(0.75f, 0.83f), // House 4  - bottom right
        floatArrayOf(0.5f, 0.83f),  // House 5  - bottom center
        floatArrayOf(0.25f, 0.83f), // House 6  - bottom left
        floatArrayOf(0.17f, 0.5f),  // House 7  - left
        floatArrayOf(0.25f, 0.17f), // House 8  - top left
        floatArrayOf(0.35f, 0.35f), // House 9  - inner top-left
        floatArrayOf(0.65f, 0.35f), // House 10 - inner top-right
        floatArrayOf(0.65f, 0.65f), // House 11 - inner bottom-right
        floatArrayOf(0.35f, 0.65f)  // House 12 - inner bottom-left
    )

    override fun onDraw(canvas: Canvas) {
        super.onDraw(canvas)
        val w = width.toFloat()
        val h = height.toFloat()
        val size = minOf(w, h)
        val offsetX = (w - size) / 2
        val offsetY = (h - size) / 2

        canvas.save()
        canvas.translate(offsetX, offsetY)
        drawChart(canvas, size)
        canvas.restore()
    }

    private fun drawChart(canvas: Canvas, size: Float) {
        val cx = size / 2
        val cy = size / 2

        // Outer square
        canvas.drawRect(0f, 0f, size, size, linePaint)

        // Diagonal lines creating the North Indian diamond pattern
        // Top diagonals
        canvas.drawLine(0f, 0f, cx, cy, linePaint)
        canvas.drawLine(size, 0f, cx, cy, linePaint)
        canvas.drawLine(0f, size, cx, cy, linePaint)
        canvas.drawLine(size, size, cx, cy, linePaint)

        // Inner square (rotated 45°)
        val inner = size * 0.35f
        val path = Path()
        path.moveTo(cx, inner)
        path.lineTo(size - inner, cy)
        path.lineTo(cx, size - inner)
        path.lineTo(inner, cy)
        path.close()
        canvas.drawPath(path, linePaint)

        // Cross lines dividing outer sections
        canvas.drawLine(cx, 0f, cx, inner, linePaint)
        canvas.drawLine(cx, size - inner, cx, size, linePaint)
        canvas.drawLine(0f, cy, inner, cy, linePaint)
        canvas.drawLine(size - inner, cy, size, cy, linePaint)

        // Draw house numbers and planets
        val planetsByHouse = planets.groupBy { it.house }

        for (houseNum in 1..12) {
            val rashi = (lagnaRashi + houseNum - 1) % 12
            val pos = housePositions[houseNum - 1]
            val px = pos[0] * size
            val py = pos[1] * size

            // Draw house number
            houseNumPaint.color = if (houseNum == 1) Color.parseColor("#00C853") else Color.parseColor("#FFD700")
            canvas.drawText(houseNum.toString(), px, py, houseNumPaint)

            // Draw rashi symbol below house number
            val symbol = Constants.ZODIAC_SYMBOLS.getOrElse(rashi) { "" }
            houseNumPaint.color = Color.parseColor("#FFD70099")
            houseNumPaint.textSize = 20f
            canvas.drawText(symbol, px, py + 22f, houseNumPaint)
            houseNumPaint.textSize = 28f

            // Draw planets in this house
            val housePlanets = planetsByHouse[houseNum] ?: emptyList()
            housePlanets.forEachIndexed { idx, planet ->
                val abbr = Constants.PLANET_ABBREVIATIONS[planet.planet] ?: planet.planet.take(2)
                val display = if (planet.isRetrograde) "R-$abbr" else abbr
                val planetY = py + 46f + idx * 22f
                canvas.drawText(display, px, planetY, planetPaint)
            }
        }
    }
}
