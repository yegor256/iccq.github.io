---
layout: default
date: 2021-02-23
title: "IEEE Electronic Copyright Form"
permalink: /ecf.html
---

## IEEE eCF Form

Review the information in this form and click "Submit" in order to transfer
your ownership rights of the intellectual property to IEEE.
The data will be sent to
[IEEE eCF system](https://www.ieee.org/publications/rights/copyright-main.html).

<script src="//code.jquery.com/jquery-1.9.0.min.js"></script>
<script>
var conf_record = 53703;
var conf_title = '2022 International Conference on Code Quality (ICCQ)';
var papers = {
  1: {
    'title': 'Foreword of Organizers',
    'authors': 'Yegor Bugayenko'
  },
  3: {
    'title': 'To What Extent Can Code Quality be Improved by Eliminating Test Smells?',
    'authors': 'Haitao Wu, Ruidi Yin, Jianhua Gao, Zijie Huang and Huajun Huang'
  },
  6: {
    'title': 'Method Name Prediction for Automatically Generated Unit Tests',
    'authors': 'Maxim Petukhov, Evelina Gudauskayte, Arman Kaliyev, Mikhail Oskin, Dmitry Ivanov and Qianxiang Wang'
  },
  11: {
    'title': 'Quasi-Dominators and Random Selection in Mutation Testing',
    'authors': 'Rowland Pitts'
  },
};
$(function() {
  let p = new URLSearchParams(window.location.search);
  let id = p.get('id');
  if (id == undefined) {
    window.location.href = "/ecf-help.html";
  }
  aid = parseInt(id);
  var details = papers[aid];
  if (details == undefined) {
    window.location.href = "/ecf-help.html";
  }
  $('input[name="ArtSource"]').val(conf_record);
  $('input[name="PubTitle"]').val(conf_title);
  $('input[name="ArtId"]').val(aid);
  $('input[name="ArtTitle"]').val(details.title);
  $('input[name="AuthName"]').val(details.authors);
});
</script>

<form action="https://ecopyright.ieee.org/ECTT/IntroPage.jsp" method="post">
  <fieldset>
    <input type="hidden" name="ArtSource" value=""/>
    <input type="hidden" name="rtrnurl" value="https://www.iccq.ru/ecf-success.html"/>
    <label>Conference Title:</label>
    <input type="text" required readonly size="50" name="PubTitle" value=""/>
    <label>Article ID:</label>
    <input type="text" required readonly size="5" name="ArtId" value=""/>
    <label>Article Title:</label>
    <input type="text" required readonly size="60" name="ArtTitle" value=""/>
    <label>Author Names:</label>
    <input type="text" required readonly size="55" name="AuthName" value=""/>
    <label>Author Emails:<sup class='firebrick'>*</sup></label>
    <input type="text" size="58" name="AuthEmail" placeholder="y.liu@ieee.org,a.smith@ieee.org"/>
    <label></label>
    <input name="Submit" type="submit" value="Submit"/>
  </fieldset>
</form>

The data you provide **won't** be stored in our website, but
will be sent directly to 
[IEEE eCF system](https://www.ieee.org/publications/rights/copyright-main.html).

If any questions, email us [team@iccq.ru](mailto:team@iccq.ru).