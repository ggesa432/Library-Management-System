package com.synergisticit.service;

import com.synergisticit.domain.Publisher;
import com.synergisticit.exception.ResourceNotFoundException;
import com.synergisticit.repository.PublisherRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class PublisherService {

    @Autowired
    private PublisherRepository publisherRepository;

    public List<Publisher> getAllPublishers() {
        return publisherRepository.findAll();
    }

    public Publisher getPublisherById(Integer id) {
        return publisherRepository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("Publisher not found with id: " + id));
    }

    public Publisher savePublisher(Publisher publisher) {
        return publisherRepository.save(publisher);
    }


}
