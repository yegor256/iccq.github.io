---
# SPDX-FileCopyrightText: Copyright (c) 2020-2025 Yegor Bugayenko
# SPDX-License-Identifier: MIT
layout: default
date: 2021-02-23
title: "IEEE Electronic Copyright Form"
permalink: /ecf.html
---

## IEEE eCF Form

Review the information in this form and click "Submit" to transfer
your ownership rights of the intellectual property to IEEE.
The data will be sent to the
[IEEE eCF system](https://www.ieee.org/publications/rights/copyright-main.html).

<script src="//code.jquery.com/jquery-1.9.0.min.js"></script>
<script>
var data = {
  2022: {
    record: 53703,
    title: '2022 International Conference on Code Quality (ICCQ)',
    papers: {
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
      }
    }
  },
  2023: {
    record: 57276,
    title: '2023 International Conference on Code Quality (ICCQ)',
    papers: {
      1: {
        'title': 'Foreword of Organizers',
        'authors': 'Yegor Bugayenko'
      },
      7753: {
        'title': 'Mutant Selection Strategies in Mutation Testing',
        'authors': 'Rowland Pitts'
      },
      3092: {
        'title': 'Understanding Software Performance Challenges - An Empirical Study on Stack Overflow',
        'authors': 'Deema Alshoaibi, Mohamed Wiem Mkaouer'
      },
      2342: {
        'title': 'Machine Learning Analysis for Software Quality Test',
        'authors': 'Al Khan, Remudin Reshid Mekuria, Ruslan Isaev'
      },
      7615: {
        'title': 'Test-based and metric-based evaluation of code generation models for practical question answering',
        'authors': 'Sergey Kovalchuk, Dmitriy Fedrushkov, Vadim Lomshakov, Artem Aliev'
      }
    }
  },
  2024: {
    record: 60895,
    title: '2024 4th International Conference on Code Quality (ICCQ)',
    papers: {
      1: {
        'title': 'Foreword of Organizers',
        'authors': 'Yegor Bugayenko'
      },
      5: {
        'title': 'Free Foil: Generating Efficient and Scope-Safe Abstract Syntax',
        'authors': 'Nikolai Kudasov, Renata Shakirova, Egor Shalagin, Karina Tyulebaeva'
      },
      8: {
        'title': 'Assessing the Code Clone Detection Capability of Large Language Models',
        'authors': 'Zixian Zhang, Takfarinas Saber'
      },
      18: {
        'title': 'Exploring the Effectiveness of Abstract Syntax Tree Patterns for Algorithm Recognition',
        'authors': 'Denis Neumüller, Florian Sihler, Raphael Straub, Matthias Tichy'
      },
      20: {
        'title': 'Replication of a Study about the Impact of Method Chaining and Comments on Readability and Comprehension',
        'authors': 'Isabel Sampaio, Alberto Sampaio'
      }
    }
  }
};
$(function() {
  let p = new URLSearchParams(window.location.search);
  let d = data[new Date().getFullYear()];
  if (d == undefined) {
    window.location.href = "/ecf-help.html";
  }
  let id = p.get('id');
  if (id == undefined) {
    window.location.href = "/ecf-help.html";
  }
  aid = parseInt(id);
  var details = d.papers[aid];
  if (details == undefined) {
    window.location.href = "/ecf-help.html";
  }
  $('input[name="ArtSource"]').val(d.record);
  $('input[name="PubTitle"]').val(d.title);
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
    <input type="text" required readonly size="7" name="ArtId" value=""/>
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
will be sent directly to the
[IEEE eCF system](https://www.ieee.org/publications/rights/copyright-main.html).

If any questions, [email us](mailto:team@iccq.ru).
