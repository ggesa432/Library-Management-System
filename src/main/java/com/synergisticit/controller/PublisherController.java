package com.synergisticit.controller;

import com.synergisticit.domain.Publisher;
import com.synergisticit.service.PublisherService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/publishers")
public class PublisherController {

    @Autowired
    private PublisherService publisherService;

    @GetMapping
    public ResponseEntity<List<Publisher>> getAllPublishers() {
        List<Publisher> publishers = publisherService.getAllPublishers();
        return ResponseEntity.ok(publishers);
    }

    @GetMapping("/{id}")
    public ResponseEntity<Publisher> getPublisherById(@PathVariable("id") Integer id) {
        Publisher publisher = publisherService.getPublisherById(id);
        return ResponseEntity.ok(publisher);
    }

    @PostMapping
    public ResponseEntity<Publisher> createPublisher(@RequestBody Publisher publisher) {
        Publisher savedPublisher = publisherService.savePublisher(publisher);
        return new ResponseEntity<>(savedPublisher, HttpStatus.CREATED);
    }

}
