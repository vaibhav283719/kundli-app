package com.vaibhav.kundli.util

import android.view.View
import android.widget.Toast
import androidx.fragment.app.Fragment
import java.text.SimpleDateFormat
import java.util.Date
import java.util.Locale

fun View.visible() { visibility = View.VISIBLE }
fun View.gone() { visibility = View.GONE }
fun View.invisible() { visibility = View.INVISIBLE }

fun View.visibleIf(condition: Boolean) {
    visibility = if (condition) View.VISIBLE else View.GONE
}

fun Fragment.showToast(message: String) {
    Toast.makeText(requireContext(), message, Toast.LENGTH_SHORT).show()
}

fun Date.formatDate(pattern: String = "dd MMM yyyy"): String {
    val sdf = SimpleDateFormat(pattern, Locale.getDefault())
    return sdf.format(this)
}

fun Date.formatDateTime(pattern: String = "dd MMM yyyy, hh:mm a"): String {
    val sdf = SimpleDateFormat(pattern, Locale.getDefault())
    return sdf.format(this)
}

fun Double.toDegreesMinutesSeconds(): String {
    val degrees = this.toInt()
    val minutesDouble = (this - degrees) * 60
    val minutes = minutesDouble.toInt()
    val seconds = ((minutesDouble - minutes) * 60).toInt()
    return "${degrees}° ${minutes}' ${seconds}\""
}

fun Int.toRashiName(): String {
    return Constants.ZODIAC_SIGNS.getOrElse(this % 12) { "Unknown" }
}

fun Int.toNakshatraName(): String {
    return Constants.NAKSHATRAS.getOrElse(this % 27) { "Unknown" }
}

fun String.capitalizeWords(): String {
    return split(" ").joinToString(" ") { word ->
        word.replaceFirstChar { if (it.isLowerCase()) it.titlecase(Locale.getDefault()) else it.toString() }
    }
}
