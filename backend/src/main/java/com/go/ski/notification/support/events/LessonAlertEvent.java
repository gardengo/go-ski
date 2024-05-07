package com.go.ski.notification.support.events;

import com.go.ski.common.util.TimeConvertor;
import com.go.ski.notification.core.domain.DeviceType;
import com.go.ski.payment.core.model.Lesson;
import com.go.ski.payment.core.model.LessonInfo;
import lombok.Getter;

import java.time.LocalDateTime;

@Getter
public class LessonAlertEvent extends NotificationEvent{

    private static final Integer NOTIFICATION_TYPE = 6;

    private final String lessonDate;
    private final String lessonTime;

    public LessonAlertEvent(
            Integer receiverId, LocalDateTime createdAt,
            Integer notificationType, DeviceType deviceType,
            String title, String lessonDate,
            String lessonTime) {
        super(receiverId, createdAt, notificationType, deviceType, title);
        this.lessonDate = lessonDate;
        this.lessonTime = lessonTime;
    }

    public static LessonAlertEvent of(LessonInfo lessonInfo, Lesson lesson, Integer receiverId, String deviceType) {
        return new LessonAlertEvent(
                receiverId,
                LocalDateTime.now(),
                NOTIFICATION_TYPE,
                DeviceType.valueOf(deviceType),
                " 강습 예약 1시간 전입니다",
                lessonInfo.getLessonDate().toString(),
                TimeConvertor.calLessonTimeInfo(lessonInfo.getStartTime(), lessonInfo.getDuration())
        );
    }

}