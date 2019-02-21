var express = require('express');
var router = express.Router();

/* GET home page. */
router.get('/', function(req, res, next) {
  res.render('./game/index', { title: 'Blockchain Monopoly games!' });
});

router.get('/join', function(req, res, next) {
  res.render('./game/gameList', { title: 'Choose a game' });
});

router.get('/leaderboard', function(req, res, next) {
  res.render('./game/leaderboard', { title: 'Player Leaderboard' });
});

router.get('/history', function(req, res, next) {
  res.render('./game/history', { title: 'Game History' });
});

router.get('/game/:id', function(req, res, next) {

});

router.post('/payload', function(req, res, next) {
  console.log(req.body);
});

module.exports = router;