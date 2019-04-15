Class {
	#name : #CuooraQuestion,
	#superclass : #WAComponent,
	#instVars : [
		'currentUser',
		'question'
	],
	#category : #'Practica1-Web'
}

{ #category : #'as yet unclassified' }
CuooraQuestion class >> withCurrentUser: anUser andQuestion: aQuestion [
	^CuooraQuestion new _currentUser: anUser; _question: aQuestion; yourself
]

{ #category : #accessing }
CuooraQuestion >> _currentUser: anUser [
	currentUser := anUser
]

{ #category : #'as yet unclassified' }
CuooraQuestion >> _question: aQuestion [
	question := aQuestion
]

{ #category : #rendering }
CuooraQuestion >> renderAnswer: anAnswer withBrush: html [
	html div
		with: [
			html div
				class: 'answer-by';
				with: [ 
					html render: 'by '.
					html anchor
						callback: [ self call: (CuooraUserProfile withCurrentUser: currentUser andProfileUser: (anAnswer user)) ];
						with: ('{1}' format: {anAnswer user name}).
			  ].
			html div
				class: 'answer-content';
				with: [
					html paragraph: (anAnswer text).
				].
			html div
				class: 'answer-info';
				with: [
					html span
						with: [ 
							html render: ('created at {1} | {2} likes | {3} dislikes' format: {
								anAnswer creation asLocalStringYMDHM.
								anAnswer reactions count: [ :reaction | reaction emotion = Emotion like ].
								anAnswer reactions count: [ :reaction | reaction emotion = Emotion dislike ].
							}).
						]
				].
			html div
				class: 'answer-react';
				with: [
					html anchor
						callback: [ 
							| reaction |
							reaction := Reaction fromUser: currentUser withEmotion: Emotion like. 
							anAnswer addReaction: reaction. 
						];
						with: 'Like'.
					html render: ' | '.
					html anchor
						callback: [
							| reaction |
							reaction := Reaction fromUser: currentUser withEmotion: Emotion dislike. 
							anAnswer addReaction: reaction. 
						];
						with: 'Dislike'.
				].
		]	
]

{ #category : #rendering }
CuooraQuestion >> renderContentOn: html [
	self renderHeaderOn: html.
	html horizontalRule.
	self renderQuestionOn: html.	
	html horizontalRule.
	self renderFooterOn: html.
]

{ #category : #rendering }
CuooraQuestion >> renderFooterOn: html [
	html paragraph: 'No more answers'.
	html anchor
		callback: [ self call: (CuooraAddAnswer withCurrentUser: currentUser toQuestion: question) ];
		with: '(+) Answer this question'
]

{ #category : #rendering }
CuooraQuestion >> renderHeaderOn: html [
	html div
		id: 'header';
		with: [
			html div
				id: 'header-left';
				with: [ html paragraph: 'CuOOra' ].
			html div
				id: 'header-right';
				with: [
					html paragraph: ('User "{1}"' format: {currentUser name}).
					html anchor
						callback: [ self call: (CuooraLogin new) ];
						with: 'Log out'.
				].
		]
]

{ #category : #rendering }
CuooraQuestion >> renderQuestionOn: html [
	RenderingHelper renderQuestion: question viewByUser: currentUser inComponent: self usingBrush: html. 
	(question answers) do: [ :answer | self renderAnswer: answer withBrush: html ].
	
]

{ #category : #hooks }
CuooraQuestion >> style [
	^	RenderingHelper style
]