package com.vaibhav.kundli.data.local.db

import androidx.room.*
import kotlinx.coroutines.flow.Flow

@Dao
interface KundliDao {
    @Insert(onConflict = OnConflictStrategy.REPLACE)
    suspend fun insert(entity: KundliChartEntity)

    @Query("SELECT * FROM kundli_charts ORDER BY created_at DESC")
    fun getAll(): Flow<List<KundliChartEntity>>

    @Query("SELECT * FROM kundli_charts WHERE id = :id")
    suspend fun getById(id: String): KundliChartEntity?

    @Delete
    suspend fun delete(entity: KundliChartEntity)

    @Query("DELETE FROM kundli_charts WHERE id = :id")
    suspend fun deleteById(id: String)

    @Query("SELECT COUNT(*) FROM kundli_charts")
    suspend fun getCount(): Int
}
