var userFollows = {};
var request = window.superagent;

function followUser(element, name, isFollow) {
  if ((userFollows[name] && userFollows[name].isFollow) || isFollow) {
    userFollows[name] = false;
    unfollowingUser(name)
      .then()
      .catch(function(err) {
        userFollows[name] = true;
      });
  } else {
    userFollows[name] = true;
    followingUser(name)
      .then()
      .catch(function(err) {
        userFollows[name] = false;
      });
  }
}

function followingUser(name) {
  return new Promise(
    function (resolve, reject) {
      request.post('/api/v1/users/followings')
        .send({ name: name })
        .type('json')
        .end(function(err, res) {
          if (err || !res.ok) {
            console.log('err!!!');
            reject(err);
          } else {
            resolve();
          }
        });
    });
}

function unfollowingUser(name) {
  return new Promise(
    function (resolve, reject) {
      request.del('/api/v1/users/followings')
        .type('json')
        .end(function(err, res) {
          if (err || !res.ok) {
            console.log('err!!!');
            reject(err);
          } else {
            resolve();
          }
        });
    });
}
