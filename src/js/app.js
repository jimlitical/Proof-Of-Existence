var photoHash = '';
App = {
    web3Provider: null,
    contracts: {},

    init: function() {
      return App.initWeb3();
    },

    initWeb3: function() {
      // Is there an injected web3 instance?
      if (typeof web3 !== 'undefined') {
        App.web3Provider = web3.currentProvider;
      } else {
        // If no injected web3 instance is detected, fall back to Ganache
        App.web3Provider = new Web3.providers.HttpProvider('http://localhost:3000');
      }
      web3 = new Web3(App.web3Provider);

      return App.initContract();
    },

    initContract: function() {
      $.getJSON('ProofOfExistence.json', function(data) {
        // Get the necessary contract artifact file and instantiate it with truffle-contract
        var poeArtifact = data;
        App.contracts.ProofOfExistence = TruffleContract(poeArtifact);

        // Set the provider for our contract
        App.contracts.ProofOfExistence.setProvider(App.web3Provider);

        return;
      });

      return App.bindEvents();
    },

    bindEvents: function() {
      $(document).on('change','#fileInput', App.setPhotoHash);
      $(document).on('click', '.btn-submit', App.addPhotoHash);
      $(document).on('click', '.btn-find', App.findPhotoTime);
    },

    setPhotoHash: function(event){
        $("#dateOutput").text("");
        $("#importantQuestion").text("");
        var file = fileInput.files[0];
        var imageType = /image.*/;

        if (file.type.match(imageType)) {
            var reader = new FileReader();

            reader.onload = function(e) {
                fileDisplayArea.innerHTML = "";

                var img = new Image();
                img.src = reader.result;
                photoHash = sha256(reader.result);
                fileDisplayArea.appendChild(img);
            }

            reader.readAsDataURL(file);
        } else {
            fileDisplayArea.innerHTML = "File not supported!"
        }
    },

    addPhotoHash: function(event) {
      event.preventDefault();

      var existenceProofInstance;

      web3.eth.getAccounts(function(error, accounts) {
        if (error) {
          console.log(error);
        }

        var account = accounts[0];

        App.contracts.ProofOfExistence.deployed().then(function(instance) {
          existenceProofInstance = instance;
          
          // Add photo's hash to the map
          return photoHash != '' ? existenceProofInstance.addPhotoToMap(photoHash, {from: account}) : 0;
        }).then(function(result) {

          var gasUsed = result.receipt.gasUsed;
          if(gasUsed > 30000){ // if gasUsed > 30000 then it means there was more gas used than if the photo was already input
            alert("You have successfully put \"" + photoHash + "\" into the map.");
          } else {
            alert("\"" + photoHash + "\" was your hash. \r\nYour photo may have already been submitted or it may have a different owner.");
          }
          return;
        }).catch(function(err) {
          console.log(err.message);
        });
      });
    },

    findPhotoTime: function(event) {
      event.preventDefault();

      var existenceProofInstance;

      web3.eth.getAccounts(function(error, accounts) {
        if (error) {
          console.log(error);
        }

        var account = accounts[0];

        App.contracts.ProofOfExistence.deployed().then(function(instance) {
          existenceProofInstance = instance;
          // Find the photo's hash in the map
          return photoHash != '' ? existenceProofInstance.getPhotoTimestamp(photoHash, {from: account}) : 0;
        }).then(function(result) {
          if(result.c[0] != 0){
            // If the result is > 0 (0 was the failed case) then we update a paragraph with the posted date
            //    this enables the user to determine if the picture was posted at the same date as what the
            //    person in the picture is holding / confirms their existence from that time
            var dateOfPhotoInput = timeConverter(result.c[0]);
            $("#dateOutput").text("Date Posted: " + dateOfPhotoInput);
            $("#importantQuestion").text("But does it match the date in the picture?!");
          } else {
            // Date posted does not exist so we reset the posted text
            $("#dateOutput").text("The photo has not been submitted yet.");
            $("#importantQuestion").text("");
          }
          return;
        }).catch(function(err) {
          console.log(err.message);
        });
      });
    }
  };

  $(function() {
    $(window).load(function() {
      App.init();
    });
  });

  // function to convert unix epoch to a human readable date
  function timeConverter(UNIX_timestamp){
    var a = new Date(UNIX_timestamp * 1000);
    var months = ['Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'];
    var year = a.getFullYear();
    var month = months[a.getMonth()];
    var date = a.getDate();
    var hour = a.getHours();
    var min = a.getMinutes();
    var sec = a.getSeconds();
    var time = date + ' ' + month + ' ' + year + ' ' + hour + ':' + min + ':' + sec ;
    return time;
  }