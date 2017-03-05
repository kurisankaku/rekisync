function followUser(name) {
  request.post('/api/v1/users/followings')
    .send({ name: name })
    .type('json')
    .end(function(err, res) {
      if (err || !res.ok) {
        console.log('err!!!');
      }
    });
}

function unfollowUser(name) {
  request.del('/api/v1/users/followings')
    .type('json')
    .end(function(err, res) {
      if (err || !res.ok) {
        console.log('err!!!');
      }
    });
}
