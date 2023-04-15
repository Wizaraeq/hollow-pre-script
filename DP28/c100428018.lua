--ヴォルカニック・エンペラー
function c100428018.initial_effect(c)
	c:EnableReviveLimit()
	c:SetSPSummonOnce(100428018)
	--splimit
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetCode(EFFECT_SPSUMMON_CONDITION)
	c:RegisterEffect(e0)
	--special summon(remove 3 monster)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(100428018,0))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	e1:SetCondition(c100428018.spcon)
	e1:SetTarget(c100428018.sptg)
	e1:SetOperation(c100428018.spop)
	e1:SetValue(SUMMON_VALUE_SELF)
	c:RegisterEffect(e1)
	--Burn and Search
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(c100428018.damcon)
	e3:SetTarget(c100428018.damtg)
	e3:SetOperation(c100428018.damop)
	e3:SetCategory(CATEGORY_DAMAGE)
	c:RegisterEffect(e3)
	--damage
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	e4:SetCondition(c100428018.damcon2)
	e4:SetOperation(c100428018.damop2)
	c:RegisterEffect(e4)
end
function c100428018.spcfilter(c,tp)
	return c:IsFaceup() and (c:IsRace(RACE_PYRO) or c:IsSetCard(0xb9)) and c:IsAbleToRemoveAsCost()
end
function c100428018.rescon(sg,e,tp)
	return Duel.GetMZoneCount(tp,sg)>0
		and ((sg:IsExists(Card.IsSetCard,1,nil,0xb9) and #sg==1)
		or sg:FilterCount(Card.IsRace,nil,RACE_PYRO)==3)
end
function c100428018.spcon(e,c)
	local c=e:GetHandler()
	if c==nil then return true end
	local tp=c:GetControler()
	local rg=Duel.GetMatchingGroup(c100428018.spcfilter,tp,LOCATION_ONFIELD+LOCATION_GRAVE,0,c)
	return #rg>0 and rg:CheckSubGroup(c100428018.rescon,1,3,e,tp)
end
function c100428018.sptg(e,tp,eg,ep,ev,re,r,rp,c)
	local c=e:GetHandler()
	local g=nil
	local rg=Duel.GetMatchingGroup(c100428018.spcfilter,tp,LOCATION_ONFIELD+LOCATION_GRAVE,0,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=rg:SelectSubGroup(tp,c100428018.rescon,false,1,3,e,tp)
	if #g>0 then
		g:KeepAlive()
		e:SetLabelObject(g)
		return true
	end
	return false
end
function c100428018.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=e:GetLabelObject()
	if not g then return end
	Duel.Remove(g,POS_FACEUP,REASON_COST)
	g:DeleteGroup()
end
function c100428018.damcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_SPECIAL+SUMMON_VALUE_SELF
end
function c100428018.damfilter(c)
	return c:IsRace(RACE_PYRO)
end
function c100428018.scfilter(c)
	return c:IsType(TYPE_TRAP) and c:IsSetCard(0x32)
end
function c100428018.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c100428018.damfilter,tp,LOCATION_REMOVED,LOCATION_REMOVED,1,nil) end
	local val=Duel.GetMatchingGroupCount(c100428018.damfilter,tp,LOCATION_REMOVED,LOCATION_REMOVED,nil)*500
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,val)
end
function c100428018.damop(e,tp,eg,ep,ev,re,r,rp)
	local val=Duel.GetMatchingGroupCount(c100428018.damfilter,tp,LOCATION_REMOVED,LOCATION_REMOVED,nil)*500
	if Duel.Damage(1-tp,val,REASON_EFFECT)~=0 and Duel.IsExistingMatchingCard(c100428018.scfilter,tp,LOCATION_DECK,0,1,nil)
		and Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.SelectYesNo(tp,aux.Stringid(100428018,2)) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
			local g=Duel.SelectMatchingCard(tp,c100428018.scfilter,tp,LOCATION_DECK,0,1,1,nil)
			Duel.ConfirmCards(1-tp,g)
			Duel.SSet(tp,g:GetFirst())
	end
end
function c100428018.cfilter(c,tp)
	return c:IsSummonPlayer(tp)
end
function c100428018.damcon2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return eg:IsExists(c100428018.cfilter,1,nil,1-tp)
end
function c100428018.damop2(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,100428018)
	Duel.Damage(1-tp,500,REASON_EFFECT)
end
