package com.vaibhav.kundli.data.local.db

import androidx.room.ColumnInfo
import androidx.room.Entity
import androidx.room.PrimaryKey

@Entity(tableName = "kundli_charts")
data class KundliChartEntity(
    @PrimaryKey
    val id: String,
    @ColumnInfo(name = "name") val name: String,
    @ColumnInfo(name = "date_of_birth") val dateOfBirth: Long,
    @ColumnInfo(name = "place_of_birth") val placeOfBirth: String,
    @ColumnInfo(name = "latitude") val latitude: Double,
    @ColumnInfo(name = "longitude") val longitude: Double,
    @ColumnInfo(name = "timezone") val timezone: Double,
    @ColumnInfo(name = "lagna_rashi") val lagnaRashi: Int,
    @ColumnInfo(name = "lagna_longitude") val lagnaLongitude: Double,
    @ColumnInfo(name = "planet_positions_json") val planetPositionsJson: String,
    @ColumnInfo(name = "house_rashis_json") val houseRashisJson: String,
    @ColumnInfo(name = "dashas_json") val dashasJson: String,
    @ColumnInfo(name = "yogas_json") val yogasJson: String,
    @ColumnInfo(name = "created_at") val createdAt: Long
)
