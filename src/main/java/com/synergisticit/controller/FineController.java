package com.synergisticit.controller;

import com.synergisticit.domain.Fine;
import com.synergisticit.exception.ResourceNotFoundException;
import com.synergisticit.repository.FineRepository;
import com.synergisticit.service.FineService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.time.temporal.ChronoUnit;
import java.util.HashMap;
import java.util.List;
import java.util.Map;


/**
 * @author GesangZeren
 * @project LibraryManagementSystem
 * @date 3/4/2025
 */
@RestController
@RequestMapping("/api/fines")
public class FineController {

    @Autowired
    private FineService fineService;
    @Autowired
    private FineRepository fineRepository;

    @GetMapping("/member/{memberId}")
    public ResponseEntity<List<Fine>> getMemberFines(@PathVariable Integer memberId) {
        List<Fine> fines = fineService.getPendingFinesForMember(memberId);
        return ResponseEntity.ok(fines);
    }

    @GetMapping("/member/{memberId}/total")
    public ResponseEntity<Map<String, Double>> getTotalFines(@PathVariable Integer memberId) {
        double totalFines = fineService.getTotalPendingFinesForMember(memberId);
        Map<String, Double> response = new HashMap<>();
        response.put("totalFines", totalFines);
        return ResponseEntity.ok(response);
    }

    @PostMapping("/{fineId}/pay")
    public ResponseEntity<Fine> payFine(@PathVariable Integer fineId) {
        Fine paidFine = fineService.payFine(fineId);
        return ResponseEntity.ok(paidFine);
    }

    @GetMapping("/all")
    public ResponseEntity<List<Fine>> getAllFines() {
        List<Fine> fines = fineService.getAllFines();
        return ResponseEntity.ok(fines);
    }

    @GetMapping("/pending")
    public ResponseEntity<List<Fine>> getAllPendingFines() {
        List<Fine> pendingFines = fineService.getAllPendingFines();
        return ResponseEntity.ok(pendingFines);
    }

    @GetMapping("/paid")
    public ResponseEntity<List<Fine>> getPaidFines() {
        List<Fine> fines = fineService.getFinesByStatus("PAID");
        return ResponseEntity.ok(fines);
    }

    @PutMapping("/rate")
    public ResponseEntity<Map<String, Double>> updateFineRate(@RequestParam Double rate) {
        fineService.updateFineRate(rate);
        Map<String, Double> response = new HashMap<>();
        response.put("newRate", rate);
        return ResponseEntity.ok(response);
    }


}


