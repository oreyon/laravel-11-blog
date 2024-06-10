<?php

// make test load homepage
test('homepage loads', function () {
    $response = $this->get('/');
    $response->assertStatus(200);
});
