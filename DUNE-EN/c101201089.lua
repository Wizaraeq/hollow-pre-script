--Crystal God Tistina
function c101201089.initial_effect(c)
	--Flip opponent's monsters face-down
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(101201089,0))
	e1:SetCategory(CATEGORY_POSITION+CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,101201089)
	e1:SetTarget(c101201089.postg)
	e1:SetOperation(c101201089.posop)
	c:RegisterEffect(e1)
	--Flip opponent's monsters face-down when destroyed
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(101201089,0))
	e2:SetCategory(CATEGORY_POSITION+CATEGORY_TOGRAVE)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_DESTROYED)
	e2:SetCountLimit(1,101201089+100)
	e2:SetCondition(c101201089.poscon)
	e2:SetTarget(c101201089.postg)
	e2:SetOperation(c101201089.posop)
	c:RegisterEffect(e2)
end
function c101201089.poscon(e,tp,eg,ep,ev,re,r,rp)
	return rp==1-tp and e:GetHandler():IsPreviousControler(tp)
end
function c101201089.postg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(Card.IsCanTurnSet,tp,0,LOCATION_MZONE,nil)
	if chk==0 then return #g>0 end
	Duel.SetOperationInfo(0,CATEGORY_POSITION,g,#g,0,0)
end
function c101201089.posop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsCanTurnSet,tp,0,LOCATION_MZONE,nil)
	if #g==0 or Duel.ChangePosition(g,POS_FACEDOWN_DEFENSE)==0 then return end
	local gg=Duel.GetMatchingGroup(Card.IsFaceup,tp,0,LOCATION_ONFIELD,nil)
	if #gg>0 and Duel.SelectYesNo(tp,aux.Stringid(101201089,1)) then
		Duel.BreakEffect()
		Duel.SendtoGrave(gg,REASON_EFFECT)
	end
end