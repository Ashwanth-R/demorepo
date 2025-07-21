package com.sivasuryaa.fooddietplanner.util;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;

/**
 * Utility class for date and time formatting operations
 */
public class DateUtils {
    
    private static final DateTimeFormatter DATE_FORMATTER = DateTimeFormatter.ofPattern("MMM dd, yyyy");
    private static final DateTimeFormatter TIME_FORMATTER = DateTimeFormatter.ofPattern("HH:mm");
    private static final DateTimeFormatter DATETIME_FORMATTER = DateTimeFormatter.ofPattern("MMM dd, yyyy HH:mm");
    
    /**
     * Format a LocalDate to a readable string
     * @param date the date to format
     * @return formatted date string
     */
    public static String formatDate(LocalDate date) {
        if (date == null) return "";
        return date.format(DATE_FORMATTER);
    }
    
    /**
     * Format a LocalDateTime to a readable date string
     * @param dateTime the datetime to format
     * @return formatted date string
     */
    public static String formatDate(LocalDateTime dateTime) {
        if (dateTime == null) return "";
        return dateTime.format(DATE_FORMATTER);
    }
    
    /**
     * Format a LocalDateTime to a readable time string
     * @param dateTime the datetime to format
     * @return formatted time string
     */
    public static String formatTime(LocalDateTime dateTime) {
        if (dateTime == null) return "";
        return dateTime.format(TIME_FORMATTER);
    }
    
    /**
     * Format a LocalDateTime to a readable datetime string
     * @param dateTime the datetime to format
     * @return formatted datetime string
     */
    public static String formatDateTime(LocalDateTime dateTime) {
        if (dateTime == null) return "";
        return dateTime.format(DATETIME_FORMATTER);
    }
    
    /**
     * Get a user-friendly description of when a date/time occurred
     * @param dateTime the datetime to describe
     * @return descriptive string like "Today", "Yesterday", or formatted date
     */
    public static String getRelativeDate(LocalDateTime dateTime) {
        if (dateTime == null) return "";
        
        LocalDate date = dateTime.toLocalDate();
        LocalDate today = LocalDate.now();
        
        if (date.equals(today)) {
            return "Today";
        } else if (date.equals(today.minusDays(1))) {
            return "Yesterday";
        } else if (date.equals(today.plusDays(1))) {
            return "Tomorrow";
        } else {
            return formatDate(date);
        }
    }
    
    /**
     * Check if a date is today
     * @param date the date to check
     * @return true if the date is today
     */
    public static boolean isToday(LocalDate date) {
        return date != null && date.equals(LocalDate.now());
    }
    
    /**
     * Check if a datetime is today
     * @param dateTime the datetime to check
     * @return true if the datetime is today
     */
    public static boolean isToday(LocalDateTime dateTime) {
        return dateTime != null && dateTime.toLocalDate().equals(LocalDate.now());
    }
}
