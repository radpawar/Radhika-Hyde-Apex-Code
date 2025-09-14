/**
 * ─────────────────────────────────────────────────────────────────────────────────────────────────
 * @class         Schedulabler for WeatherBatchController
 * @TestClass      
 * @description    Handle High volumn of data
 * ──────────────────────────────────────────────────────────────────────────────────────────────────
 */
public with sharing class ScheduleWeatherBatchClass implements Schedulable {
    public void execute(SchedulableContext sc) {
        ID BatchId = Database.executeBatch(new WeatherBatchController(), 100);
    }
}