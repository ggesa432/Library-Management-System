package com.synergisticit.service;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;

/**
 * @author GesangZeren
 * @project LibraryManagementSystem
 * @date 3/4/2025
 */
@Service
public class EmailService {

    @Value("${spring.mail.enabled:false}")
    private boolean mailEnabled;

    public void sendEmail(String to, String subject, String body) {
        // In a real application, this would use JavaMailSender to send actual emails
        // For now, we'll just log the email
        System.out.println("Sending email to: " + to);
        System.out.println("Subject: " + subject);
        System.out.println("Body: " + body);

        // Here you would connect to an SMTP server and send the actual email
    }
}
