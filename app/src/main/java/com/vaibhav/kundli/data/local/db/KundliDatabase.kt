package com.vaibhav.kundli.data.local.db

import android.content.Context
import androidx.room.Database
import androidx.room.Room
import androidx.room.RoomDatabase
import dagger.Module
import dagger.Provides
import dagger.hilt.InstallIn
import dagger.hilt.android.qualifiers.ApplicationContext
import dagger.hilt.components.SingletonComponent
import javax.inject.Singleton

@Database(entities = [KundliChartEntity::class], version = 1, exportSchema = false)
abstract class KundliDatabase : RoomDatabase() {
    abstract fun kundliDao(): KundliDao
}

@Module
@InstallIn(SingletonComponent::class)
object DatabaseModule {
    @Provides
    @Singleton
    fun provideKundliDatabase(@ApplicationContext context: Context): KundliDatabase {
        return Room.databaseBuilder(context, KundliDatabase::class.java, "kundli_database")
            .fallbackToDestructiveMigration()
            .build()
    }

    @Provides
    @Singleton
    fun provideKundliDao(database: KundliDatabase): KundliDao = database.kundliDao()
}
