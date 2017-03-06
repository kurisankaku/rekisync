var userFollows = {};
var request = window.superagent;

function followUser(element, name, isFollow) {
  if ((userFollows[name] && userFollows[name].isFollow) || isFollow) {
    userFollows[name] = false;
    element.innerHTML = "フォロー";
    unfollowingUser(name)
      .then()
      .catch(function(err) {
        userFollows[name] = true;
        element.innerHTML = "アンフォロー";
      });
  } else {
    userFollows[name] = true;
    element.innerHTML = "アンフォロー";
    followingUser(name)
      .then()
      .catch(function(err) {
        userFollows[name] = false;
        element.innerHTML = "フォロー";
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
