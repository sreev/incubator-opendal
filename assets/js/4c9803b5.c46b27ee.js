"use strict";(self.webpackChunkopendal_website=self.webpackChunkopendal_website||[]).push([[1715],{5721:(e,n,t)=>{t.r(n),t.d(n,{assets:()=>s,contentTitle:()=>r,default:()=>h,frontMatter:()=>d,metadata:()=>a,toc:()=>c});const a=JSON.parse('{"id":"pmc_members/nominate-pmc-member","title":"Nominate PMC Member","description":"This document mainly introduces how a PMC member nominates a new PMC member.","source":"@site/community/pmc_members/nominate-pmc-member.md","sourceDirName":"pmc_members","slug":"/pmc_members/nominate-pmc-member","permalink":"/community/pmc_members/nominate-pmc-member","draft":false,"unlisted":false,"editUrl":"https://github.com/apache/opendal/tree/main/website/community/pmc_members/nominate-pmc-member.md","tags":[],"version":"current","sidebarPosition":3,"frontMatter":{"title":"Nominate PMC Member","sidebar_position":3},"sidebar":"docs","previous":{"title":"Nominate Committer","permalink":"/community/pmc_members/nominate-committer"},"next":{"title":"Board reporting","permalink":"/community/pmc_members/board-reporting"}}');var i=t(6070),o=t(5658);const d={title:"Nominate PMC Member",sidebar_position:3},r=void 0,s={},c=[{value:"Start vote about the candidate",id:"start-vote-about-the-candidate",level:2},{value:"Send NOTICE to Board after VOTE PASSED",id:"send-notice-to-board-after-vote-passed",level:2},{value:"Send invitation to the candidate",id:"send-invitation-to-the-candidate",level:2},{value:"Add the candidate to the PMC member list",id:"add-the-candidate-to-the-pmc-member-list",level:2}];function m(e){const n={a:"a",code:"code",h2:"h2",img:"img",li:"li",p:"p",pre:"pre",ul:"ul",...(0,o.R)(),...e.components};return(0,i.jsxs)(i.Fragment,{children:[(0,i.jsx)(n.p,{children:"This document mainly introduces how a PMC member nominates a new PMC member."}),"\n",(0,i.jsx)(n.h2,{id:"start-vote-about-the-candidate",children:"Start vote about the candidate"}),"\n",(0,i.jsxs)(n.p,{children:["Start a vote about the candidate via sending email to: ",(0,i.jsx)(n.a,{href:"mailto:private@opendal.apache.org",children:"private@opendal.apache.org"}),":"]}),"\n",(0,i.jsxs)(n.ul,{children:["\n",(0,i.jsx)(n.li,{children:"candidate_name: The full name of the candidate."}),"\n",(0,i.jsx)(n.li,{children:"candidate_github_id: The GitHub id of the candidate."}),"\n"]}),"\n",(0,i.jsx)(n.p,{children:"Title:"}),"\n",(0,i.jsx)(n.pre,{children:(0,i.jsx)(n.code,{children:"[VOTE] Add candidate ${candidate_name} as a new PMC member\n"})}),"\n",(0,i.jsx)(n.p,{children:"Content:"}),"\n",(0,i.jsx)(n.pre,{children:(0,i.jsx)(n.code,{children:"Hi, All OpenDAL PMC members.\n  \nI would like to nominate ${candidate_name} (GitHub id: ${candidate_github_id}) as a candidate for the OpenDAL PMC member. Since becoming an OpenDAL committer, ${candidate_name} has made significant contributions to various modules of the project.\n\n${candidate_name}'s great contributions could be found:\n\n- Github Account: https://github.com/${candidate_github_id}\n- Github Pull Requests: https://github.com/apache/opendal/pulls?q=is%3Apr+author%3A${candidate_github_id}+is%3Aclosed\n- Github Issues: https://github.com/apache/opendal/issues?q=is%3Aopen+mentions%3A${candidate_github_id}\n\nPlease make your valuable evaluation on whether we could invite ${candidate_name} as a\nPMC member:\n\n[ +1 ] Agree to add ${candidate_name} as a PMC member of OpenDAL.\n[ 0  ] Have no sense.\n[ -1 ] Disagree to add ${candidate_name} as a PMC member of OpenDAL, because .....\n\nThis vote starts from the moment of sending and will be open for 3 days.\n \nThanks and best regards,\n\n${your_name}\n"})}),"\n",(0,i.jsxs)(n.p,{children:["Example: ",(0,i.jsx)(n.a,{href:"https://lists.apache.org/thread/yg2gz2tof3cvbrgp1wxzk6mf9o858h7t",children:"https://lists.apache.org/thread/yg2gz2tof3cvbrgp1wxzk6mf9o858h7t"})," (Private Link)"]}),"\n",(0,i.jsxs)(n.p,{children:["After at least 3 ",(0,i.jsx)(n.code,{children:"+1"})," binding vote and no veto, claim the vote result:"]}),"\n",(0,i.jsx)(n.p,{children:"Title:"}),"\n",(0,i.jsx)(n.pre,{children:(0,i.jsx)(n.code,{children:"[RESULT][VOTE] Add candidate ${candidate_name} as a new PMC member\n"})}),"\n",(0,i.jsx)(n.p,{children:"Content:"}),"\n",(0,i.jsx)(n.pre,{children:(0,i.jsx)(n.code,{children:"Hi, all:\n\nThe vote for \"Add candidate ${candidate_name} as a new PMC member\" has PASSED and closed now.\n\nThe result is as follows:\n\n4 binding +1 Votes:\n- voter names\n\nVote thread: https://lists.apache.org/thread/yg2gz2tof3cvbrgp1wxzk6mf9o858h7t\n\nThen I'm going to invite ${candidate_name} to join us.\n\nThanks for everyone's support!\n\n${your_name}\n"})}),"\n",(0,i.jsx)(n.h2,{id:"send-notice-to-board-after-vote-passed",children:"Send NOTICE to Board after VOTE PASSED"}),"\n",(0,i.jsxs)(n.p,{children:["The nominating PMC member should send a message to the Board ",(0,i.jsx)(n.a,{href:"mailto:board@apache.org",children:"board@apache.org"})," with a reference to the vote result in the following form:"]}),"\n",(0,i.jsx)(n.p,{children:"Title:"}),"\n",(0,i.jsx)(n.pre,{children:(0,i.jsx)(n.code,{children:"[NOTICE] ${candidate_name} for Apache OpenDAL PMC\n"})}),"\n",(0,i.jsx)(n.p,{children:"Content:"}),"\n",(0,i.jsx)(n.pre,{children:(0,i.jsx)(n.code,{children:"${candidate_name} has been voted as a new member of the Apache OpenDAL PMC. the vote thread is at: \n\nhttps://lists.apache.org/thread/yg2gz2tof3cvbrgp1wxzk6mf9o858h7t\n"})}),"\n",(0,i.jsx)(n.h2,{id:"send-invitation-to-the-candidate",children:"Send invitation to the candidate"}),"\n",(0,i.jsxs)(n.p,{children:["Send an invitation to the candidate and cc ",(0,i.jsx)(n.a,{href:"mailto:private@opendal.apache.org",children:"private@opendal.apache.org"}),":"]}),"\n",(0,i.jsx)(n.p,{children:"Title:"}),"\n",(0,i.jsx)(n.pre,{children:(0,i.jsx)(n.code,{children:"Invitation to become Apache OpenDAL PMC Member: ${candidate_name}\n"})}),"\n",(0,i.jsx)(n.p,{children:"Content:"}),"\n",(0,i.jsx)(n.pre,{children:(0,i.jsx)(n.code,{children:"Hello ${candidate_name},\n\nIn recognition of your contributions to Apache OpenDAL, the OpenDAL PMC has recently voted to add you as a PMC member. The role of a PMC member grants you access to the Project Management Committee (PMC) and enables you to take on greater responsibilities within the OpenDAL project. We hope that you accept this invitation and continue to help us make Apache OpenDAL better.\n\nPlease reply to private@opendal.apache.org using the 'reply all' function for your responses.\n\nWith the expectation of your acceptance, welcome!\n\n${your_name} (as represents of The Apache OpenDAL PMC)\n"})}),"\n",(0,i.jsx)(n.h2,{id:"add-the-candidate-to-the-pmc-member-list",children:"Add the candidate to the PMC member list"}),"\n",(0,i.jsxs)(n.p,{children:["After the candidate accepts the invitation, add the candidate to the PMC member list by ",(0,i.jsx)(n.a,{href:"https://whimsy.apache.org/roster/committee/opendal",children:"whimsy roster tools"})]}),"\n",(0,i.jsx)(n.p,{children:(0,i.jsx)(n.img,{src:t(7286).A+"",width:"1248",height:"924"})})]})}function h(e={}){const{wrapper:n}={...(0,o.R)(),...e.components};return n?(0,i.jsx)(n,{...e,children:(0,i.jsx)(m,{...e})}):m(e)}},7286:(e,n,t)=>{t.d(n,{A:()=>a});const a=t.p+"assets/images/roster-add-pmc-member-e054bc1c41af11ec5a6bf37ae926636d.png"},5658:(e,n,t)=>{t.d(n,{R:()=>d,x:()=>r});var a=t(758);const i={},o=a.createContext(i);function d(e){const n=a.useContext(o);return a.useMemo((function(){return"function"==typeof e?e(n):{...n,...e}}),[n,e])}function r(e){let n;return n=e.disableParentContext?"function"==typeof e.components?e.components(i):e.components||i:d(e.components),a.createElement(o.Provider,{value:n},e.children)}}}]);